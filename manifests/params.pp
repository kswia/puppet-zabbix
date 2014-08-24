# == Class: zabbix::params
#
# The zabbix configuration settings.
#
class zabbix::params {

  case $::operatingsystem {

    'Ubuntu', 'Debian': {

      $agent_package = 'zabbix-agent'
      $server_package = 'zabbix-server-mysql'
      $frontend_package = 'zabbix-frontend-php'

      $agent_conf_file = '/etc/zabbix/zabbix_agentd.conf'
      $server_conf_file = '/etc/zabbix/zabbix_server.conf'
      $frontend_conf_file   = '/etc/zabbix/web/zabbix.conf.php'
      $frontend_apache_conf_file   = '/etc/apache2/conf.d/zabbix'
      $frontend_php_ini_file = '/etc/php5/conf.d/zabbix.ini'

      $agent_service_name = 'zabbix-agent'
      $server_service_name = 'zabbix-server'

      $agent_log_file     = '/var/log/zabbix/zabbix_agentd.log'
      $server_log_file     = '/var/log/zabbix/zabbix_server.log'

      $agent_pid_file       = '/var/run/zabbix/zabbix_agentd.pid'

      $python_package_mysql = 'python-mysqldb'
      $python_package_simplejson = 'python-simplejson'
      $python_package_sqlalchemy = 'python-sqlalchemy'

      $prepare_schema_command = 'cat /usr/share/zabbix-server-mysql/schema.sql /usr/share/zabbix-server-mysql/images.sql > /tmp/zabbix-schema-tmp/all.sql'

      $agent_include_path   = '/etc/zabbix/zabbix_agentd.d'
      $agent_scripts_path   = '/etc/zabbix/scripts'
      $zabbix_sender_binary = '/usr/bin/zabbix_sender'

      $frontend_docroot = '/usr/share/zabbix'

    }
    'CentOS', 'RedHat': {

      $agent_package = 'zabbix-agent'
      $server_package = 'zabbix-server-mysql'
      $frontend_package     = 'zabbix-web-mysql'

      $agent_conf_file = '/etc/zabbix/zabbix_agentd.conf'
      $server_conf_file = '/etc/zabbix/zabbix_server.conf'
      $frontend_conf_file   = '/etc/zabbix/web/zabbix.conf.php'
      $frontend_apache_conf_file   = '/etc/apache2/conf.d/zabbix'
      $frontend_php_ini_file = '/etc/php5/conf.d/zabbix.ini'

      $agent_service_name = 'zabbix-agent'
      $server_service_name = 'zabbix-server'

      $agent_log_file     = '/var/log/zabbix/zabbix_agentd.log'
      $server_log_file     = '/var/log/zabbix/zabbix_server.log'

      $agent_pid_file       = '/var/run/zabbix/zabbix_agentd.pid'

      $python_package_mysql = 'MySQL-python'
      $python_package_simplejson = 'python-simplejson'
      $python_package_sqlalchemy = 'python-sqlalchemy'

      $prepare_schema_command = 'cat /usr/share/doc/zabbix-server-mysql-`zabbix_server -V | awk \'/v[0-9].[0-9].[0-9]/{print substr($3, 2)}\'`/create/schema.sql /usr/share/doc/zabbix-server-mysql-`zabbix_server -V | awk \'/v[0-9].[0-9].[0-9]/{print substr($3, 2)}\'`/create/images.sql > /tmp/zabbix-schema-tmp/all.sql'

      $agent_include_path   = '/etc/zabbix/zabbix_agentd.d'
      $agent_scripts_path   = '/etc/zabbix/scripts'
      $zabbix_sender_binary = '/usr/bin/zabbix_sender'

      $frontend_docroot = '/usr/share/zabbix'

    }
    default: {

      fail("Module ${module_name} is not supported on ${::operatingsystem}")

    }

  }

}
