class zabbix::db::postgresql (
  $db_name     = 'zabbix',
  $db_user     = 'zabbix',
  $db_password = 'zabbix'
) {
  include zabbix::params

}