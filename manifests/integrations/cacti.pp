# Class: stackstate_agent::integrations::cacti
#
# This class will install the necessary configuration for the cacti integration
#
# Parameters:
#   $host:
#       The host cacti MySQL db is running on
#   $user
#       The cacti MySQL password 
#   $password
#       The cacti MySQL sb port.
#   $path
#       The path to the cacti rrd directory e.g. /var/lib/cacti/rra/
#
class stackstate_agent::integrations::cacti(
  $mysql_host = 'localhost',
  $mysql_user = 'cacti',
  $mysql_password = undef,
  $rrd_path = '/var/lib/cacti/rra/',
) inherits stackstate_agent::params {
  include stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/cacti.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/cacti.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
