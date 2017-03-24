# Class: stackstate_agent::ubuntu
#
# This class contains the StackState agent installation mechanism for Ubuntu
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#

class stackstate_agent::ubuntu(
  $apt_key = '382E94DE',
  $agent_version = 'latest',
  $other_keys = ['C7A7DA52']
) {

  ensure_packages(['apt-transport-https'])
  validate_array($other_keys)

  if !$::stackstate_agent::skip_apt_key_trusting {
    $mykeys = concat($other_keys, [$apt_key])

    ::stackstate_agent::ubuntu::install_key { $mykeys:
      before  => File['/etc/apt/sources.list.d/stackstate.list'],
    }

  }

  file { '/etc/apt/sources.list.d/stackstate.list':
    source  => 'puppet:///modules/stackstate_agent/stackstate.list',
    owner   => 'root',
    group   => 'root',
    notify  => Exec['stackstate_apt-get_update'],
    require => Package['apt-transport-https'],
  }

  exec { 'stackstate_apt-get_update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    tries       => 2, # https://bugs.launchpad.net/launchpad/+bug/1430011 won't get fixed until 16.04 xenial
    try_sleep   => 30,
  }

  package { 'stackstate-agent-base':
    ensure => absent,
    before => Package['stackstate-agent'],
  }

  package { 'stackstate-agent':
    ensure  => $agent_version,
    require => [File['/etc/apt/sources.list.d/stackstate.list'],
                Exec['stackstate_apt-get_update']],
  }

  service { 'stackstate-agent':
    ensure    => $::stackstate_agent::service_ensure,
    enable    => $::stackstate_agent::service_enable,
    hasstatus => false,
    pattern   => 'sts-agent',
    require   => Package['stackstate-agent'],
  }

}
