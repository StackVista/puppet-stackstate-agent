# Class: stackstate_agent::integrations::mesos_master
#
# This class will install the necessary configuration for the mesos integration
#
# Parameters:
#   $url:
#     The URL for Mesos master
#
# Sample Usage:
#
#   class { 'stackstate_agent::integrations::mesos' :
#     url  => "http://localhost:5050"
#   }
#
class stackstate_agent::integrations::mesos_master(
  $mesos_timeout = 10,
  $url = 'http://localhost:5050'
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/mesos.yaml":
    ensure => 'absent'
  }

  file { "${stackstate_agent::params::conf_dir}/mesos_master.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0644',
    content => template('stackstate_agent/agent-conf.d/mesos_master.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
