# Class: stackstate_agent::integrations::mesos_slave
#
# This class will install the necessary configuration for the mesos slave integration
#
# Parameters:
#   $url:
#     The URL for Mesos slave
#
# Sample Usage:
#
#   class { 'stackstate_agent::integrations::mesos' :
#     url  => "http://localhost:5051"
#   }
#
class stackstate_agent::integrations::mesos_slave(
  $mesos_timeout = 10,
  $url = 'http://localhost:5051'
) inherits stackstate_agent::params {

  file { "${stackstate_agent::params::conf_dir}/mesos_slave.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0644',
    content => template('stackstate_agent/agent-conf.d/mesos_slave.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
