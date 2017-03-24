# Class: stackstate_agent::integrations::redis
#
# This class will install the necessary configuration for the redis integration
#
# Parameters:
#   $host:
#       The host redis is running on
#   $password
#       The redis password (optional)
#   $port
#       The main redis port.
#   $ports
#       Array of redis ports: overrides port (optional)
#   $slowlog_max_len
#       The max length of the slow-query log (optional)
#   $tags
#       Optional array of tags
#   $keys
#       Optional array of keys to check length
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::redis' :
#    host => 'localhost',
#  }
#
#
class stackstate_agent::integrations::redis(
  $host = 'localhost',
  $password = '',
  $port = '6379',
  $ports = undef,
  $slowlog_max_len = '',
  $tags = [],
  $keys = [],
  $warn_on_missing_keys = true,
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_array($tags)
  validate_array($keys)
  validate_bool($warn_on_missing_keys)

  if $ports == undef {
    $_ports = [ $port ]
  } else {
    $_ports = $ports
  }

  validate_array($_ports)

  file { "${stackstate_agent::params::conf_dir}/redisdb.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/redisdb.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
