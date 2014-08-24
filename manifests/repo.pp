# == Class: zabbix::repo
#
# The zabbix external repository configuration.
#
class zabbix::repo {

  case $::operatingsystem {

    'Ubuntu': {
      case $::lsbdistcodename {
        'trusty': {
          apt::source { 'zabbix':
            location   => 'http://repo.zabbix.com/zabbix/2.2/ubuntu',
            repos      => 'main',
            release    => 'precise',
            key        => '79EA5ED4',
            key_server => 'keys.gnupg.net'
          }
        }
        'precise': {
          apt::source { 'zabbix':
            location   => 'http://repo.zabbix.com/zabbix/2.2/ubuntu',
            repos      => 'main',
            release    => 'precise',
            key        => '79EA5ED4',
            key_server => 'keys.gnupg.net'
          }
        }
        'lucid': {
          apt::source { 'zabbix':
            location   => 'http://repo.zabbix.com/zabbix/2.2/ubuntu',
            repos      => 'main',
            release    => 'lucid',
            key        => '79EA5ED4',
            key_server => 'keys.gnupg.net'
          }
        }
        default: {
          fail("Module ${module_name} is not supported on ${::lsbdistcodename}")
        }
      }

    }

    'Debian': {
      case $::lsbdistcodename {
        'squeeze': {
          apt::source { 'zabbix':
            location   => 'http://repo.zabbix.com/zabbix/2.2/debian',
            repos      => 'main',
            release    => 'squeeze',
            key        => '79EA5ED4',
            key_server => 'keys.gnupg.net'
          }
        }
        'wheezy': {
          apt::source { 'zabbix':
            location   => 'http://repo.zabbix.com/zabbix/2.2/debian',
            repos      => 'main',
            release    => 'wheezy',
            key        => '79EA5ED4',
            key_server => 'keys.gnupg.net'
          }
        }
        default: {
          fail("Module ${module_name} is not supported on ${::lsbdistcodename}")
        }
      }
    }

    'RedHat', 'CentOS': {
      yumrepo { 'zabbix':
        descr     => 'Zabbix Official Repository',
        baseurl   => 'http://repo.zabbix.com/zabbix/2.2/rhel/$releasever/$basearch/',
        gpgkey    => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        gpgcheck  => 1,
        enabled   => 1,
      }
      yumrepo { 'zabbix-non-supported':
        descr     => 'Zabbix Official Repository non-supported',
        baseurl   => 'http://repo.zabbix.com/non-supported/rhel/$releasever/$basearch/',
        gpgkey    => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        gpgcheck  => 1,
        enabled   => 1,
      }
    }

    'Gentoo': {
      file { '/etc/portage/package.use/10_zabbix':
        ensure    => present,
        content   => 'net-analyzer/zabbix curl'
      }
    }

    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }

  }
}
