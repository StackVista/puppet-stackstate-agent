# Class: stackstate_agent::integrations::docker_daemon
#
# This class will install the necessary configuration for the docker integration
#
# Parameters:
#   $url:
#     The URL for docker API
#
#   $tags:
#     optional array of tags
#
#   $group:
#     optional name of docker group to add sts-agent user too
#
#
# Sample Usage:
#
#   class { 'stackstate_agent::integrations::docker_daemon' :
#     url           => 'unix://var/run/docker.sock',
#   }
#
class stackstate_agent::integrations::docker_daemon(
  $url = 'unix://var/run/docker.sock',
  $tags = [],
  $group = 'docker',
) inherits stackstate_agent::params {
  include stackstate_agent

  exec { 'sts-agent-should-be-in-docker-group':
    command => "/usr/sbin/usermod -aG ${group} ${stackstate_agent::params::dd_user}",
    unless  => "/bin/cat /etc/group | grep '^${group}:' | grep -qw ${stackstate_agent::params::dd_user}",
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }

  file { "${stackstate_agent::params::conf_dir}/docker.yaml":
    ensure => 'absent'
  }

  file { "${stackstate_agent::params::conf_dir}/docker_daemon.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0644',
    content => template('stackstate_agent/agent-conf.d/docker_daemon.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
