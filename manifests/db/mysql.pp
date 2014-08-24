class zabbix::db::mysql (
  $db_name     = 'zabbix',
  $db_user     = 'zabbix',
  $db_password = 'zabbix',
) {

  include zabbix::params

  file { '/tmp/zabbix-schema-tmp':
    ensure => directory,
    mode   => '0755',
  }


  exec { 'prepare-schema-import':
    command       => $zabbix::params::prepare_schema_command,
    creates       => '/tmp/zabbix-schema-tmp/all.sql',
    require       => [
      Package[$zabbix::params::server_package],
      File['/tmp/zabbix-schema-tmp']
    ],
    path          => ['/usr/sbin', '/usr/bin', '/sbin', '/bin' ],
  }


  class { 'mysql::server':
    config_hash => {
      # the priv grant fails on precise if I set a root password
      # TODO I should make sure that this works
      # 'root_password' => $mysql_root_password,
      'root_password' => 'zabbix_mysql_password',
      'bind_address'  => '0.0.0.0'
    },
    enabled     => true,
  }

  mysql::db { $db_name:
    user          => $db_user,
    password      => $db_password,
    host          => 'localhost',
    sql           => '/tmp/zabbix-schema-tmp/all.sql',
    require       => [
      Class['mysql::server'],
      Class['mysql::config'],
      Package[$zabbix::params::server_package],
      Exec['prepare-schema-import'],
    ],
  }

}
