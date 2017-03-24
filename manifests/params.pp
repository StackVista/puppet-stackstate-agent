# Class: stackstate_agent::params
#
# This class contains the parameters for the StackState module
#
# Parameters:
#   $api_key:
#       Your StackState API Key. Please replace with your key value
#   $dd_url
#       The URL to the StackState application.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class stackstate_agent::params {
  $conf_dir       = '/etc/sts-agent/conf.d'
  $dd_user        = 'sts-agent'
  $dd_group       = 'root'
  $package_name   = 'stackstate-agent'
  $service_name   = 'stackstate-agent'
  $dogapi_version = 'installed'
  $conf_dir_purge = false

  case $::operatingsystem {
    'Ubuntu','Debian' : {
      $rubydev_package   =  'ruby-dev'
    }
    'RedHat','CentOS','Fedora','Amazon','Scientific' : {
      $rubydev_package   = 'ruby-devel'
    }
    default: { fail("Class[stackstate_agent]: Unsupported operatingsystem: ${::operatingsystem}") }
  }

}
