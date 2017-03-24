# Class: stackstate_agent::integrations::ceph
#
# This class will install the necessary configuration for the ceph integration
#
# Parameters:

# Sample Usage:
#
#  class { 'stackstate_agent::integrations::ceph' :
#  }
#
class stackstate_agent::integrations::ceph(
) inherits stackstate_agent::params {
  include stackstate_agent

  file { '/etc/sudoers.d/stackstate_ceph':
    content => "# This file is required for dd ceph \nsts-agent ALL=(ALL) NOPASSWD:/usr/bin/ceph\n"
  }

  file { "${stackstate_agent::params::conf_dir}/ceph.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/ceph.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
