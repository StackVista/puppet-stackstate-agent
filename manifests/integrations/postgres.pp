# Class: stackstate_agent::integrations::postgres
#
# This class will install the necessary configuration for the postgres integration
#
# Parameters:
#   $password
#       The password for the stackstate user
#   $host:
#       The host postgres is running on
#   $dbname
#       The postgres database name
#   $port
#       The postgres port number
#   $username
#       The username for the stackstate user
#   $use_psycopg2
#       Boolean to flag connecting to postgres with psycopg2 instead of pg8000.
#       Warning, psycopg2 doesn't support ssl mode.
#   $tags
#       Optional array of tags
#   $tables
#       Track per relation/table metrics. Array of strings.
#       Warning: this can collect lots of metrics per relation
#       (10 + 10 per index)
#   $tags
#       Optional array of tags
#   $custom_metrics
#       A hash of custom metrics with the following keys - query, metrics,
#       relation, descriptors. Refer to this guide for details on those fields:
#       https://help.stackstate.com/hc/en-us/articles/208385813-Postgres-custom-metric-collection-explained
#
# Sample Usage:
#
#  class { 'stackstate_agent::integrations::postgres' :
#    host     => 'localhost',
#    dbname   => 'postgres'
#    username => 'stackstate',
#    password => 'some_pass',
#    custom_metrics => {
#      a_custom_query => {
#        query => "select tag_column, %s from table",
#        relation => false,
#        metrics => {
#          value_column => ["value_column.stackstate.tag", "GAUGE"]
#        },
#        descriptors => [
#          ["tag_column", "tag_column.stackstate.tag"]
#        ]
#      }
#    }
#  }
#
#
class stackstate_agent::integrations::postgres(
  $password,
  $host   = 'localhost',
  $dbname = 'postgres',
  $port   = '5432',
  $username = 'stackstate',
  $use_psycopg2 = false,
  $tags = [],
  $tables = [],
  $custom_metrics = {},
) inherits stackstate_agent::params {
  include stackstate_agent

  validate_array($tags)
  validate_array($tables)
  validate_bool($use_psycopg2)

  file { "${stackstate_agent::params::conf_dir}/postgres.yaml":
    ensure  => file,
    owner   => $stackstate_agent::params::dd_user,
    group   => $stackstate_agent::params::dd_group,
    mode    => '0600',
    content => template('stackstate_agent/agent-conf.d/postgres.yaml.erb'),
    require => Package[$stackstate_agent::params::package_name],
    notify  => Service[$stackstate_agent::params::service_name],
  }

  create_resources('stackstate_agent::integrations::postgres_custom_metric', $custom_metrics)
}
