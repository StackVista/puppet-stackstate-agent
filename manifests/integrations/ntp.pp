# Class: stackstate_agent::integrations::ntp
#
# This class will enable ntp check
#
# Parameters:
#   $offset_threshold:
#        Offset threshold for a critical alert. Defaults to 600.
#
#   $host:
#        ntp server to use for ntp check
#
#   $port
#
#   $version
#
#   $timeout
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::ntp' :
#    offset_threshold     => 60,
#    host                 => 'pool.ntp.org',
#  }
#

class stackstate_agent::integrations::ntp(
  $offset_threshold = 60,
  $host             = undef,
  $port             = undef,
  $version          = undef,
  $timeout          = undef,
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/ntp.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/ntp.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
