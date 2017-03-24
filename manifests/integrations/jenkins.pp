# Class: stackstate_agent::integrations::jenkins
#
# This class will install the necessary configuration for the jenkins integration
#
# Parameters:
#   $path:
#       Jenkins path. Defaults to '/var/lib/jenkins'
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::jenkins' :
#    path     => '/var/lib/jenkins',
#  }
#
#
class stackstate_agent::integrations::jenkins(
  $path = '/var/lib/jenkins'
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/jenkins.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/jenkins.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
