# Class: stackstate_agent::integrations::memcache
#
# This class will install the necessary configuration for the memcache integration
#
# Parameters:
#   $url:
#       url used to connect to the memcached instance
#   $port:
#   $tags
#       Optional array of tags
#
# Sample Usage:
#
# include 'stackstate_agent::integrations::memcache'
#
# OR
#
# class { 'stackstate_agent::integrations::memcache':
#   url      => 'localhost',
# }
#
class stackstate_agent::integrations::memcache (
  $url                    = 'localhost',
  $port                   = 11211,
  $tags                   = [],
  $items                  = false,
  $slabs                  = false,
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_string($url)
  validate_array($tags)
  validate_integer($port)

  file { "${stackstate_agent::params::conf_dir}/mcache.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/mcache.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
