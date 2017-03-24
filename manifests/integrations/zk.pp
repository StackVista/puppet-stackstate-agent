# Class: stackstate_agent::integrations::zk
#
# This class will install the necessary configuration for the zk integration
#
# Parameters:
#   $host:
#       The host zk is running on. Defaults to '127.0.0.1'
#   $port
#       The port zk is running on. Defaults to 2181
#   $tags
#       Optional array of tags
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::zk' :
#    servers => [
#      {
#        'host' => 'localhost',
#        'port' => '2181',
#        'tags' => [],
#      },
#      {
#        'host' => 'localhost',
#        'port' => '2182',
#        'tags' => [],
#      },
#    ]
#  }
#
class stackstate_agent::integrations::zk (
  $servers = [{'host' => 'localhost', 'port' => '2181'}]
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_array($servers)

  file { "${stackstate_agent::params::conf_dir}/zk.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/zk.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
