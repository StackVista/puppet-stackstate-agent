# Class: stackstate_agent::integrations::varnish
#
# This class will install the necessary configuration for the varnish integration
#
# Parameters:
#   varnishstat
#       Path to the varnishstat binary
#
#   instance_name
#       Used in the varnishstat command for the -n argument
#
#   tags
#       StackState tags
#
# Sample usage:
#
# include 'stackstate_agent::integrations::varnish'
#
# class { 'stackstate_agent::integrations::varnish':
#   url      => '/usr/bin/varnishstat',
#   tags     => ['env:production'],
# }
#
class stackstate_agent::integrations::varnish (
  $varnishstat   = '/usr/bin/varnishstat',
  $instance_name = undef,
  $tags          = [],
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/varnish.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/varnish.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
