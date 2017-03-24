# Class: stackstate_agent::integrations::pgbouncer
#
# This class will install the necessary configuration for the pgbouncer integration
#
# Parameters:
#   $password
#       The password for the stackstate user
#   $host:
#       The host pgbouncer is listening on
#   $port
#       The pgbouncer port number
#   $username
#       The username for the stackstate user
#   $tags
#       Optional array of tags
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::pgbouncer' :
#    host     => 'localhost',
#    username => 'stackstate',
#    port     => '6432',
#    password => 'some_pass',
#  }
#
#
class stackstate_agent::integrations::pgbouncer(
  $password,
  $host   = 'localhost',
  $port   = '6432',
  $username = 'stackstate',
  $tags = [],
) inherits stackstate_agent::params {

  validate_array($tags)

  file { "${stackstate_agent::params::conf_dir}/pgbouncer.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/pgbouncer.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name],
  }
}
