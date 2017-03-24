# Class: stackstate_agent::integrations::riak
#
# This class will install the necessary configuration for the riak integration
#
# Parameters:
#   $url:
#     The URL for riak
#   $tags
#       Optional array of tags
#
# Sample Usage:
#
#   include 'stackstate_agent::integrations::riak'
#
#   OR
#
#   class { 'stackstate_agent::integrations::riak' :
#     url   => 'http://localhost:8098/stats',
#   }
#
class stackstate_agent::integrations::riak(
  $url   = 'http://localhost:8098/stats',
  $tags  = [],
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_string($url)
  validate_array($tags)

  file {
    "${stackstate_agent::params::conf_dir}/riak.yaml":
      ensure  => file,
      owner   => $stackstate_agent::params::dd_user,
      group   => $stackstate_agent::params::dd_group,
      mode    => '0644',
      content => template('stackstate_agent/agent-conf.d/riak.yaml.erb'),
      require => Package[$stackstate_agent::params::package_name],
      notify  => Service[$stackstate_agent::params::service_name]
  }
}
