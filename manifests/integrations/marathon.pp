# Class: stackstate_agent::integrations::marathon
#
# This class will install the necessary configuration for the Marathon integration
#
# Parameters:
#   $url:
#     The URL for Marathon
#
# Sample Usage:
#
#   class { 'stackstate_agent::integrations::marathon' :
#     url  => "http://localhost:8080"
#   }
#
class stackstate_agent::integrations::marathon(
  $marathon_timeout = 5,
  $url = 'http://localhost:8080'
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/marathon.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0644',
    content => template('stackstate_agent/agent-conf.d/marathon.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
