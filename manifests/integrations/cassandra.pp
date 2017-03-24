# Class: stackstate_agent::integrations::cassandra
#
# This class will install the necessary configuration for the Cassandra
# integration
#
# Parameters:
#   $host:
#       The hostname Cassandra is running on
#   $port:
#       The port to connect on
#   $user
#       The user for the stackstate user
#   $password
#       The password for the stackstate user
#   $tags
#       Optional array of tags
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::cassandra' :
#    host     => 'localhost',
#    tags     => {
#      environment => "production",
#    },
#  }
#
#
class stackstate_agent::integrations::cassandra(
  $host = 'localhost',
  $port = 7199,
  $user = undef,
  $password = undef,
  $tags = {},
) inherits stackstate_agent::params {
  require ::stackstate_agent
  validate_hash($tags)

  file { "${stackstate_agent::params::conf_dir}/cassandra.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/cassandra.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name],
  }
}
