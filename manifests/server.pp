# == Class: zabbix::server
#
# KAMIL
#
# Set up a Zabbix server
#
# === Parameters
#
# [*ensure*]
#  present or abenst
# [*hostname*]
#  hostname of local machine
# [*export*]
#  present or absent, use storeconfigs to inform clients of server location
# [*conf_file*]
#  path to configuration file
# [*template*]
#  name of puppet template used
# [*node_id*]
# [*db_server*]
#  mysql server hostname
# [*db_database*]
#  mysql server schema name
# [*db_user*]
#  mysql server username
# [*db_password*]
#  mysql server password
#
class zabbix::server (
  $cluster_identifier  = 'default',
  $configure_firewall  = true,
  $node_id             = '0',
  $db_type             = 'mysql',
  $db_host             = 'localhost',
  $db_name             = 'zabbix',
  $db_user             = 'zabbix',
  $db_password         = 'zabbix',
  $frontend_servername = $::fqdn,
  $api_debug           = 'false',
  $server_ip           = $::ipaddress,
  $server_listen_port  = '10051',
) {

  include ::zabbix::params
  include ::zabbix::repo

  class { '::zabbix::frontend':
    db_type     => $db_type,
    db_name     => $db_name,
    db_user     => $db_user,
    db_password => $db_password,
    servername  => $frontend_servername,
    server_ip   => $server_ip,
  }

  class { '::zabbix::api':
    servername  => $frontend_servername,
    debug       => $api_debug,
  }

  class { '::zabbix::db':
    db_type     => $db_type,
    db_name     => $db_name,
    db_user     => $db_user,
    db_password => $db_password,
  }

  if $configure_firewall {
    firewall {'991 zabbix server':
      port   => $zabbix::params::server_listen_port,
      proto  => 'tcp',
      action => 'accept',
    }
  }
  
  @@zabbix::serverconfig { $::fqdn:
    ip  => $server_ip,
    tag => "cluster-${cluster_identifier}"
  }

  package { 'zabbix-server':
    ensure => latest,
    name   => $zabbix::params::server_package,
  }

  file { 'zabbix_server.conf':
    ensure  => present,
    name    => $zabbix::params::server_conf_file,
    content => template('zabbix/zabbix_server.conf.erb'),
    notify  => Service['zabbix-server'],
    require => Package['zabbix-server']
  }

  service { 'zabbix-server':
    ensure  => running,
    name    => $zabbix::params::server_service_name,
    enable  => true,
    require => [
      File['zabbix_server.conf'],
      Class['zabbix::db'],
    ],
  }

  zabbix_hostgroup { 'ManagedByPuppet': }

  Zabbix_host {
    require => Zabbix_hostgroup['ManagedByPuppet']
  }

  zabbix_host { 'Zabbix server':
    ensure => absent
  }

  File['zabbix_server.conf'] ~> Service['zabbix-server']

  Class['zabbix::api'] ->
  Zabbix_hostgroup['ManagedByPuppet'] ->
  Zabbix_host <<| tag == "cluster-${cluster_identifier}" |>> ->
  Zabbix_template_link <<| tag == "cluster-${cluster_identifier}" |>> ->
  Zabbix_usermacro <<| tag == "cluster-${cluster_identifier}" |>>

}
