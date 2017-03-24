# Class: stackstate_agent::integrations::directory
#
# This class will install the necessary config to hook the directory check
#
# Parameters:
#   $directory
#       The directory to gather stats for
#   $tag_name
#       The name used to tag the metrics (directory alias)
#   $pattern
#       The `fnmatch` pattern to use when reading the "directory"'s files. default "*"
#   $recursive
#       Boolean, when true the stats will recurse into directories
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::directory' :
#      directory     => '/mnt/media',
#      tag_name      => 'name',
#      pattern       => '*',
#      recursive     => true,
#  }
class stackstate_agent::integrations::directory (
  $directory     = undef,
  $tag_name      = '',
  $pattern       = '*',
  $recursive     = false
) inherits stackstate_agent::params {

  if $directory == undef {
    fail('you must specify a directory path within the stackstate_agent::integrations::directory class')
  }

  file { "${stackstate_agent::params::conf_dir}/directory.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/directory.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
