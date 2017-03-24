# Class: stackstate_agent::integrations::php_fpm
#
# This class will set-up PHP FPM monitoring
#
# Parameters:
#   $status_url
#        URL to fetch FPM metrics. Default: http://localhost/status
#
#   $ping_url
#        URL to get a reliable check of the FPM pool. Default: http://localhost/ping
#
#   $tags
#        Optional array of tags
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::php_fpm' :
#    status_url     => 'http://localhost/fpm_status',
#    ping_url       => 'http://localhost/fpm_ping'
#  }
#

class stackstate_agent::integrations::php_fpm(
  $status_url       = 'http://localhost/status',
  $ping_url         = 'http://localhost/ping',
  $http_host        = undef,
  $tags             = [],
  $instances        = undef
) inherits stackstate_agent::params {
  include stackstate_agent

  if !$instances {
    $_instances = [{
      'http_host' => $http_host,
      'status_url' => $status_url,
      'ping_url' => $ping_url,
      'tags' => $tags,
    }]
  } else {
    $_instances = $instances
  }

  file { "${stackstate_agent::params::conf_dir}/php_fpm.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/php_fpm.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
