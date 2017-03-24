# Class: stackstate_agent::integrations::tomcat
#
# This class will install the necessary configuration for the tomcat integration
#
# Parameters:
#   $hostname:
#       The host tomcat is running on. Defaults to 'localhost'
#   $port
#       The JMX port.
#   $username
#       The username for connecting to the running JVM. Optional.
#   $password
#       The password for connecting to the running JVM. Optional.
#   $java_bin_path
#       The path to the Java binary. Should be set if the agent cannot find your java executable. Optional.
#   $trust_store_path
#       The path to the trust store. Should be set if ssl is enabled. Optional.
#   $trust_store_password
#       The trust store password. Should be set if ssl is enabled. Optional.
#   $tags
#       Optional hash of tags { env => 'prod' }.
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::tomcat':
#    port => 8081,
#  }
#
class stackstate_agent::integrations::tomcat(
  $hostname             = 'localhost',
  $port                 = 7199,
  $username             = undef,
  $password             = undef,
  $java_bin_path        = undef,
  $trust_store_path     = undef,
  $trust_store_password = undef,
  $tags                 = {},
) inherits stackstate_agent::params {
  include stackstate_agent


  file { "${stackstate_agent::params::conf_dir}/tomcat.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/tomcat.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name]
  }

}
