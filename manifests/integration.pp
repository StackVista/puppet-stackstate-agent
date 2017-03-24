define stackstate_agent::integration (
  $instances,
  $init_config = undef,
  $integration = $title,
){

  include stackstate_agent

  validate_array($instances)
  if $init_config != undef {
    validate_hash($init_config)
  }
  validate_string($integration)

  file { "${stackstate_agent::conf_dir}/${integration}.yaml":
    ensure  => file,
    owner   => $stackstate_agent::dd_user,
    group   => $stackstate_agent::dd_group,
    mode    => '0600',
    content => to_instances_yaml($init_config, $instances),
    notify  => Service[$stackstate_agent::service_name]
  }

}
