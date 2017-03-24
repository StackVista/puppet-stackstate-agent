# Class: stackstate_agent::integrations::fluentd
#
# This class will install the fluentd integration
#
# Parameters:
#   $monitor_agent_url
#       The url fluentd lists it's plugins on
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::fluentd' :
#    monitor_agent_url     => 'http://localhost:24220/api/plugins.json',
#    plugin_ids => [
#     'elasticsearch_out',
#     'rsyslog_in',
#   ],
#  }
#
#
class stackstate_agent::integrations::fluentd(
  $monitor_agent_url = 'http://localhost:24220/api/plugins.json',
  $plugin_ids = [],
) inherits stackstate_agent::params {
  include ::stackstate_agent

  validate_array($plugin_ids)

  file { "${stackstate_agent::params::conf_dir}/fluentd.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/fluentd.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name],
  }
}
