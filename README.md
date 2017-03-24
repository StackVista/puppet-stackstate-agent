Puppet & StackState
================


Description
-----------

A module to:

1. install the [StackState](http://www.stackstate.com) agent
2. to send reports of puppet runs to the StackState service [StackState](http://www.stackstate.com/).

Requirements
------------

Puppet >=2.7.x and <=4.2.x (we may work with newer versions, but untested). For detailed informations on compatibility, check the [module page](https://forge.puppetlabs.com/stackstate/stackstate_agent) on the Puppet forge.

Installation
------------

Install `stackstate_agent` as a module in your Puppet master's module path.

    puppet module install stackstate-stackstate_agent


Usage
-----

Once the `stackstate_agent` module is installed on your master, there's a tiny bit of configuration
that needs to be done.

1. Update the default class parameters with your [API key]

2. Specify the module on any nodes you wish to install the StackState
   Agent.

        include stackstate_agent

  Or assign this module using the Puppet style Parameterized class:
        class { 'stackstate_agent':
          api_key => "yourkey",
        }

  On your Puppet master, enable reporting:

        class { 'stackstate_agent':
          api_key            => "yourkey",
          puppet_run_reports => true,
        }

  __To support reporting, your Puppet master needs to have the [stsapi](https://github.com/StackState/stsapi-rb) gem installed, to do that either run the puppet agent on your master with this configuration or install it manually with `gem`.__
  _Please note if on Puppet Enterprise or POSS (ie. >=3.7.0) there is a soft dependency for reporting on the `puppetserver_gem` module. Install with `puppet module install puppetlabs-puppetserver_gem` - installing manually with `gem` will *not* work._
  _Also note that we have made the gem provider configurable, so you can set it to `puppetserver_gem` (already set by default) if on PE/POSS (>=3.7.0) or `gem` if on older versions of puppet_

3. Include any other integrations you want the agent to use, e.g.

        include 'stackstate_agent::integrations::mongo'

Reporting
---------
To enable reporting of changes to the StackState timeline, enable the report
processor on your Puppet master, and enable reporting for your clients.
The clients will send a run report after each check-in back to the master.

Make sure you enable the `puppet_run_reports` option to true in the node
configuration manifest for your master.

```ruby
class { "stackstate-agent":
    api_key => "<your_api_key>",
    puppet_run_reports => true
    # ...
}
```

In your Puppet master `/etc/puppet/puppet.conf`, add these configuration options:

```ini
[main]
# No need to modify this section
# ...

[master]
# Enable reporting to stackstate
reports=stackstate_reports
# If you use other reports already, just add stackstate_reports at the end
# reports=store,log,stackstate_reports
# ...

[agent]
# ...
pluginsync=true
report=true
```

And on all of your Puppet client nodes add:

```ini
[agent]
# ...
report=true
```

If you get

```
err: Could not send report:
Error 400 on SERVER: Could not autoload stackstate_reports:
Class StackState_reports is already defined in Puppet::Reports
```

Make sure `reports=stackstate_reports` is defined in **[master]**, not **[main]**.

Step-by-step
============

This is the minimal set of modifications to get started. These files assume puppet 2.7.x or higher.

/etc/puppet/puppet.conf
-----------------------

    [master]
    report = true
    reports = stackstate_reports
    pluginsync = true

    [agent]
    report = true
    pluginsync = true

/etc/puppet/manifests/nodes.pp
------------------------------

    node "default" {
        class { "stackstate_agent":
            api_key => "INSERT YOU API KEY HERE",
        }
    }
    node "puppetmaster" {
        class { "stackstate_agent":
            api_key            => "INSERT YOUR API KEY HERE",
            puppet_run_reports => true
        }
    }

/etc/puppet/manifests/site.pp
-----------------------------

    import "nodes.pp"

Run Puppet Agent
----------------

    sudo /etc/init.d/puppetmaster restart
    sudo puppet agent --onetime --no-daemonize --no-splay --verbose

You should see something like:

    info: Retrieving plugin
    info: Caching catalog for alq-linux.dev.stackstate.com
    info: Applying configuration version '1333470114'
    notice: Finished catalog run in 0.81 seconds

Verify on StackState
-----------------

Todo

Masterless puppet
=================

This is a specific setup, you can use https://gist.github.com/LeoCavaille/cd412c7a9ff5caec462f to set it up.

Client Settings
===============

### Tagging client nodes

The stackstate agent configuration file will be recreated from the template every puppet run. If you need to tag your nodes, add an array entry in hiera

        stackstate_agent::local_tags
        - 'keyname:value'
        - 'anotherkey:%{factname}'

Here are some of the other variables that be set in the stackstate_agent class to control settings in the agent:

| variable name | description |
| ------------- | ----------- |
| collect_ec2_tags | Set this to yes to have an instance's custom EC2 tags used as agent tags |
| collect_instance_metadata | Set this to yes to have an instance's EC2 metadata used as agent tags |
| dd_url        | stackstate intake server URL. You are unlikely to need to change this |
| host          | overrides the node's hostname |
| local_tags    | an array of key:value strings that will be set as tags for the node |
| non_local_traffic | set this to allow other nodes to relay their traffic through this one |

### Proxy Settings

If you need to connect to the internet through a proxy, you can set `proxy_host`, `proxy_port`, `proxy_user` and `proxy_password`.


Module Development and Testing
==============================

### Clone the repo

```
git clone git@github.com:StackVista/puppet-stackstate-agent.git
cd puppet-stackstate-agent
```

### Install dependencies

```
bundle install
rake lint              # Check puppet manifests with puppet-lint / Run puppet-lint
rake spec              # Run spec tests in a clean fixtures directory
rake syntax            # Syntax check Puppet manifests and templates
rake syntax:manifests  # Syntax check Puppet manifests
rake syntax:templates  # Syntax check Puppet templates
pip install pre-commit
pre-commit install
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

