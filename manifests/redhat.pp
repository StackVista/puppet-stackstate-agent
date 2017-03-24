# Class: stackstate_agent::redhat
#
# This class contains the StackState agent installation mechanism for Red Hat derivatives
#
# Parameters:
#   $baseurl:
#       Baseurl for the stackstate yum repo
#       Defaults to http://yum.stackstate.com/rpm/${::architecture}/
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#
class stackstate_agent::redhat(
  $baseurl = "https://yum.stackstate.com/rpm/${::architecture}/",
  $gpgkey = 'https://yum.stackstate.com/STACKSTATE_RPM_KEY_E09422B3.public',
  $manage_repo = true,
  $agent_version = 'latest'
) {

  validate_bool($manage_repo)
  if $manage_repo {
    $public_key_local = '/tmp/STACKSTATE_RPM_KEY.public'

    validate_string($baseurl)

    remote_file { 'STACKSTATE_RPM_KEY.public':
        owner  => root,
        group  => root,
        mode   => '600',
        path   => $public_key_local,
        source => $gpgkey
    }

    exec { 'install-gpg-key':
        command => "/bin/rpm --import ${public_key_local}",
        onlyif  => "/usr/bin/gpg --quiet --with-fingerprint -n ${public_key_local} | grep \'A4C0 B90D 7443 CF6E 4E8A  A341 F106 8E14 E094 22B3\'",
        unless  => '/bin/rpm -q gpg-pubkey-e09422b3',
        require => Remote_file['STACKSTATE_RPM_KEY.public'],
        notify  => Exec['cleanup-gpg-key'],
    }

    exec { 'cleanup-gpg-key':
        command => "/bin/rm ${public_key_local}",
        onlyif  => "/usr/bin/test -f ${public_key_local}",
    }

    yumrepo {'stackstate':
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'https://yum.stackstate.com/STACKSTATE_RPM_KEY.public',
      descr    => 'StackState',
      baseurl  => $baseurl,
      require  => Exec['install-gpg-key'],
    }

    Package { require => Yumrepo['stackstate']}
  }

  package { 'stackstate-agent-base':
    ensure => absent,
    before => Package['stackstate-agent'],
  }

  package { 'stackstate-agent':
    ensure  => $agent_version,
  }

  service { 'stackstate-agent':
    ensure    => $::stackstate_agent::service_ensure,
    enable    => $::stackstate_agent::service_enable,
    hasstatus => false,
    pattern   => 'sts-agent',
    provider  => 'redhat',
    require   => Package['stackstate-agent'],
  }

}
