# Class: stackstate_agent::integrations::supervisord
#
# This class will install the necessary configuration for the supervisord integration
#
# Parameters:
#   servername
#   socket
#       Optional. The socket on which supervisor listen for HTTP/XML-RPC requests. 
#   hostname
#       Optional. The host where supervisord server is running. 
#   port
#       Optional. The port number.
#   username
#   password
#       If your service uses basic authentication, you can optionally
#       specify a username and password that will be used in the check.
#   proc_names
#       Optional. The process to monitor within this supervisord instance.
#       If not specified, the check will monitor all processes. 
#   server_check
#       Optional. Service check for connections to supervisord server.
#
#
# Sample Usage:
#
# class { 'stackstate_agent::integrations::supervisord':
#   instances => [
#     {
#       servername => 'server0',
#       socket     => 'unix:///var/run//supervisor.sock',
#     },
#     {
#       servername => 'server1',
#       hostname   => 'localhost',
#       port       => '9001',
#       proc_names => ['java', 'apache2'],
#     },
#   ],
# }
#
#
#

class stackstate_agent::integrations::supervisord (
  $instances    = [{'servername' => 'server0', 'hostname' => 'localhost', 'port' => '9001'}],
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/supervisord.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/supervisord.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
