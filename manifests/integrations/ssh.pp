# Class: stackstate_agent::integrations::ssh
#
# This class will enable ssh check
#
# Parameters:
#   $host:
#        ssh server to use for ssh check
#
#   $port
#
#   $username
#
#   $password
#
#   $sftp_check
#
#   $private_key_file
#
#   $add_missing_keys
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::ssh' :
#    host             => 'localhost',
#    private_key_file => '/opt/super_secret_key',
#  }
#

class stackstate_agent::integrations::ssh(
  $host              = $::fqdn,
  $port              = 22,
  $username          = $stackstate_agent::params::dd_user,
  $password          = undef,
  $sftp_check        = true,
  $private_key_file  = undef,
  $add_missing_keys  = true,
) inherits stackstate_agent::params {
  include ::stackstate_agent

  file { "${stackstate_agent::params::conf_dir}/ssh.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/ssh.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }
}
