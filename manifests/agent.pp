# == Class: zabbix::agent
#
# Install and manage a zabbix agent. Have a look at zabbix::agent::userparameter if you
# need to use custom UserParameters.
#
class zabbix::agent (
  $cluster_identifier = 'default',
  $configure_firewall = true,
  $agent_listen_port = '10050',
) {

  include zabbix::params
  include zabbix::repo


  if $configure_firewall {
    firewall {'990 zabbix agent':
      port   => $zabbix::params::agent_listen_port,
      proto  => 'tcp',
      action => 'accept',
    }
  }

  package { 'zabbix-agent':
    ensure => latest,
    name   => $zabbix::params::agent_package,
  }

  file { 'zabbix_agentd.d':
    ensure  => directory,
    name    => $zabbix::params::agent_include_path,
    mode    => '0500',
    owner   => 'zabbix',
    group   => 'zabbix',
    require => Package[$zabbix::params::agent_package]
  }

  Zabbix::Serverconfig <<| tag == "cluster-${cluster_identifier}" |>> {
    notify  => Service['zabbix-agent'],
    require => File['zabbix_agentd.d']
  }

  file { 'zabbix_agentd.conf':
    ensure  => present,
    name    => $zabbix::params::agent_conf_file,
    content => template('zabbix/zabbix_agentd.conf.erb'),
    notify  => Service['zabbix-agent'],
    require => Package['zabbix-agent']
  }

  service { 'zabbix-agent':
    ensure  => running,
    name    => $zabbix::params::agent_service_name,
    enable  => true,
    require => File['zabbix_agentd.conf']
  }

  @@zabbix_host { $::fqdn:
    host    => $::fqdn,
    ip      => $::ipaddress_eth0,
    groups  => 'ManagedByPuppet',
    tag     => "cluster-${cluster_identifier}"
  }

}
