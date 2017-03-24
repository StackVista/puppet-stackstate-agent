# Class: stackstate_agent::integrations::generic
#
# This class will install a configuration file for an integration
#
# Parameters:
#   $integration_name:
#       This will be used to build the filename. It must correspond to an
#         integration that is supported by sts-agent, see the sts-agent for
#         a current list.
#   $integration_contents:
#       String containing a rendered template.
#
# Sample Usage:
#
# class { 'stackstate_agent::integrations::generic':
#   integration_name     => 'custom',
#   integration_contents => template(my_custom_template),
# }
#
class stackstate_agent::integrations::generic(
  $integration_name     = undef,
  $integration_contents = undef,
) inherits stackstate_agent::params {

  validate_string($integration_name)
  validate_string($integration_contents)

  file { "${stackstate_agent::params::conf_dir}/${integration_name}.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => $integration_contents,
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
