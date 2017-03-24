# Class: stackstate_agent::integrations::nginx
#
# This class will install the necessary configuration for the nginx integration
#
# Parameters:
#   $instances:
#       Array of hashes for all nginx urls and associates tags. See example
#
# Sample Usage:
#
#   class { 'stackstate_agent::integrations::nginx':
#     instances => [
#         {
#             'nginx_status_url'  => 'http://example.com/nginx_status/',
#         },
#         {
#             'nginx_status_url'  => 'http://example2.com:1234/nginx_status/',
#             'tags' => ['instance:foo'],
#         },
#     ],
#   }
#
#
#
class stackstate_agent::integrations::nginx(
  $instances = [],
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_array($instances)

  file { "${stackstate_agent::params::conf_dir}/nginx.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/nginx.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
