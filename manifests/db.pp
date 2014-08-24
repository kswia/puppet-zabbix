class zabbix::db (
  $db_type     = 'mysql',
  $db_name     = 'zabbix',
  $db_user     = 'zabbix',
  $db_password = 'zabbix'
) {

  case $db_type {
    'mysql': {
      class { 'zabbix::db::mysql':
        db_name     => $db_name,
        db_user     => $db_user,
        db_password => $db_password,
      }
    }
    'postgresql': {
      class { 'zabbix::db::postgresql':
        db_name     => $db_name,
        db_user     => $db_user,
        db_password => $db_password,
      }
    }
    default: {
      fail("Database type ${db_type} is not supported in module ${module_name}")
    }
  }

}