# Class: stackstate_agent::reports
#
# This class configures the puppetmaster for reporting back to
# the stackstate service.
#
# Parameters:
#   $api_key:
#       Your StackState API Key. Please replace with your key value
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class stackstate_agent::reports(
  $api_key,
  $puppet_gem_provider,
  $puppetmaster_user,
  $dogapi_version,
  $hostname_extraction_regex = nil
) {

  include stackstate_agent::params
  $rubydev_package = $stackstate_agent::params::rubydev_package

  # check to make sure that you're not installing rubydev somewhere else
  if ! defined(Package[$rubydev_package]) {
    package {$rubydev_package:
      ensure => installed,
      before => Package['dogapi']
    }
  }

  if (! defined(Package['rubygems'])) {
    # Ensure rubygems is installed
    class { 'ruby':
      rubygems_update => false
    }
  }

  file { '/etc/sts-agent/stackstate.yaml':
    ensure  => file,
    content => template('stackstate_agent/stackstate.yaml.erb'),
    owner   => $puppetmaster_user,
    group   => 'root',
    mode    => '0640',
    require => File['/etc/sts-agent'],
  }

  package{'dogapi':
    ensure   => $dogapi_version,
    provider => $puppet_gem_provider,
  }
}
