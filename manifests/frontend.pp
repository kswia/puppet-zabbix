# == Class: zabbix::frontend
#
# Install and manage zabbix frontend
#
class zabbix::frontend (
  $servername  = $::fqdn,
  $db_host     = 'localhost',
  $db_type     = 'mysql',
  $db_name     = undef,
  $db_user     = undef,
  $db_password = undef,
  $db_port     = '3306',
  $server_ip   = $::ipaddress,
) {

  include ::zabbix::params
  class { '::apache':
    mpm_module => 'prefork',
  }

  class { '::apache::mod::php':  }

  package { $zabbix::params::frontend_package:
    ensure    => present,
  }

  file { $zabbix::params::frontend_apache_conf_file:
    ensure    => absent,
    require   => Package[$zabbix::params::frontend_package],
  }

  apache::vhost { 'zabbix':
    port               => '80',
    priority           => '20',
    docroot            => $zabbix::params::frontend_docroot,
    servername         => $servername,
    require            => [ Package[$zabbix::params::frontend_package], File[$zabbix::params::frontend_apache_conf_file] ],
    ssl                => false,
    directories        => [
      { path            => $zabbix::params::frontend_docroot,
        order           => 'Allow,Deny',
        allow           => 'from all',
        allow_override  => 'None',
        options         => 'FollowSymLinks',
        php_admin_value => ['max_execution_time', '300',
                            'memory_limit', '128M',
                            'post_max_size', '16M',
                            'upload_max_filesize', '2M',
                            'max_input_time', '300']
      },
      { path  => "${zabbix::params::frontend_docroot}/conf",
        order => 'Deny,Allow',
        deny  => 'from all',
      },
      { path  => "${zabbix::params::frontend_docroot}/api",
        order => 'Deny,Allow',
        deny  => 'from all',
      },
      { path  => "${zabbix::params::frontend_docroot}/include",
        order => 'Deny,Allow',
        deny  => 'from all',
      },
      { path  => "${zabbix::params::frontend_docroot}/include/classes",
        order => 'Deny,Allow',
        deny  => 'from all',
      }
    ]

  }

  file { $zabbix::params::frontend_conf_file:
    ensure  => present,
    mode    => '0644',
    content => template('zabbix/zabbix.conf.php.erb'),
    require => Package[$zabbix::params::frontend_package]
  }

  file { $zabbix::params::frontend_php_ini_file:
    ensure  => present,
    content => template('zabbix/zabbix_php_ini.erb'),
    notify  => Service[$::apache::params::service_name],
    require => Package[$::zabbix::params::frontend_package]
  }

}
