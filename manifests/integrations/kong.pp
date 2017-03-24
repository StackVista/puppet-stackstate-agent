# Class: stackstate_agent::integrations::kong
#
# This class will install the necessary configuration for the Kong integration
#
# Note: if you're Cassandra data-store is large in size the `/status` page may
# take a long time to return.
# <https://github.com/Mashape/kong/issues/1323>
#
# Parameters:
#   $instances:
#       Array of hashes for all Kong instances and associated tags. See example
#
# Sample Usage:
#
#   class { 'stackstate_agent::integrations::kong':
#     instances => [
#         {
#             'status_url'  => http://localhost:8001/status/',
#         },
#         {
#             'status_url'  => 'http://localhost:8001/status/',
#             'tags' => ['instance:foo'],
#         },
#     ],
#   }
#
class stackstate_agent::integrations::kong (
  $instances = [
    {
      'status_url' => 'http://localhost:8001/status/',
      'tags' => []
    }
  ]
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/kong.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0644',
    content => template('stackstate_agent/agent-conf.d/kong.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
