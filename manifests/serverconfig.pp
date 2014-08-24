# == Define: zabbix::serverconfig
#
# Create a zabbix server config file in agent conf.d
#
# === Parameters
# [*ip*]
#   ip address of zabbix server
#
# === Example Usage
#
#   zabbix::serverconfig { 'Zabbix server':
#     ip => '192.168.0.10',
#   }
#
define zabbix::serverconfig (
  $ip = $::zabbix::params::server_ip,
) {

  include zabbix::params

  file { "${zabbix::params::agent_include_path}/server.conf":
    content => template('zabbix/zabbix_agent_server_include.conf.erb')
  }

}