# Class: stackstate_agent::integrations::haproxy
#
# This class will install the necessary configuration for the haproxy integration
#
# Parameters:
#   $url:
#     The URL for haproxy
#
# Sample Usage:
#
#   class { 'stackstate_agent::integrations::haproxy' :
#     url   => 'http://localhost:8080',
#     creds => { username => 'admin',
#                password => 'password',
#              },
#   }
#
class stackstate_agent::integrations::haproxy(
  $creds     = {},
  $url       = "http://${::ipaddress}:8080",
  $instances = undef,
) inherits stackstate_agent::params {
  include stackstate_agent

  if !$instances and $url {
    $_instances = [{
      'creds' => $creds,
      'url'   => $url,
    }]
  } elsif !$instances {
    $_instances = []
  } else {
    $_instances = $instances
  }

  file {
    "${stackstate_agent::params::conf_dir}/haproxy.yaml":
      ensure  => file,
      owner   => $stackstate_agent::params::dd_user,
      group   => $stackstate_agent::params::dd_group,
      mode    => '0644',
      content => template('stackstate_agent/agent-conf.d/haproxy.yaml.erb'),
      require => Package[$stackstate_agent::params::package_name],
      notify  => Service[$stackstate_agent::params::service_name]
  }
}
