# Class: stackstate_agent::integrations::process
#
# This class will install the necessary configuration for the process integration
#
# Parameters:
#   $processes:
#       Array of process hashes. See example
#
# Process hash keys:
#   search_strings
#       LIST OF STRINGS If one of the element in the list matches,
#       return the counter of all the processes that contain the string
#
#   exact_match
#       True/False, default to True, if you want to look for an arbitrary
#       string, use exact_match: False, unless use the exact base name of the process
#
#   cpu_check_interval
#       CPU percent check interval: 0.1 - 1.0 sec. More time - more precise
#       Optional
#
# Sample Usage:
#
# class { 'stackstate_agent::integrations::process':
#     processes   => [
#         {
#             'name'          => 'puppetmaster',
#             'search_string' => ['puppet master'],
#             'exact_match'   => false,
#         },
#         {
#             'name'          => 'sshd',
#             'search_string' => ['/usr/sbin/sshd'],
#             'exact_match'   => true,
#         },
#     ],
# }

#
#
class stackstate_agent::integrations::process(
  $processes = [],
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_array( $processes )

  file { "${stackstate_agent::params::conf_dir}/process.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/process.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
