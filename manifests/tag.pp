# Allow custom tags via a define
define stackstate_agent::tag(
  $tag = $name,
  $lookup_fact = false,
){

  if $lookup_fact{
    $value = getvar($tag)

    if is_array($value){
      $tags = prefix($value, "${tag}:")
      stackstate_agent::tag{$tags: }
    } else {
      if $value {
        concat::fragment{ "stackstate tag ${tag}:${value}":
          target  => '/etc/sts-agent/stackstate.conf',
          content => "${tag}:${value}, ",
          order   => '03',
        }
      }
    }
  } else {
    concat::fragment{ "stackstate tag ${tag}":
      target  => '/etc/sts-agent/stackstate.conf',
      content => "${tag}, ",
      order   => '03',
    }
  }

}
