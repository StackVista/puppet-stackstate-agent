# Class: stackstate_agent::integrations::dns_check
#
# This class will install the necessary configuration for the DNS check
# integration.
#
# Parameters:
#   $hostname:
#       Domain or IP you wish to check the availability of.
#   $nameserver
#       The nameserver you wish to use to check the hostname
#       availability.
#   $timeout
#       Time in seconds to wait before terminating the request.
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::dns_check':
#    checks => [
#      {
#        'hostname'   => 'example.com',
#        'nameserver' => '8.8.8.8',
#        'timeout'    => 5,
#      }
#    ]
#  }
#
class stackstate_agent::integrations::dns_check (
  $checks = [
    {
      'hostname'   => 'google.com',
      'nameserver' => '8.8.8.8',
      'timeout'    => 5,
    }
  ]
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_array($checks)

  file { "${stackstate_agent::params::conf_dir}/dns_check.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/dns_check.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name],
  }
}
