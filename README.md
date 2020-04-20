# sauron

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with sauron](#setup)
    * [What sauron affects](#what-sauron-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sauron](#beginning-with-sauron)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module sets up [Sauron](https://github.com/flyingrocket/sauron), a Python
script for monitoring disk space on remote systems over SSH, to watch your
remote boxen. 

Should work on any platform that supports Python.

Each host in your network can be assigned a customized configuration in Hiera
or by class parameters. This module uses exported resources, so you need to
have PuppetDB running and configured.

## Setup

### What sauron affects

Besides installing the script and setting up cron jobs, Sauron will create a
user on both monitored ("client") and monitoring ("server") systems and a file
structure in its home directory for tmp and log files.

We rely on the vcsrepo module to clone Sauron from Github.

Config files are installed in /etc/sauron:

* a ''global'' config file `puppet.config.yaml`
* a ''services'' config file with per-node specific configurations,
    `puppet.services.yaml`

### Setup Requirements 

At the moment, you need Git installed to put Sauron in place (on the "server" only).

### Beginning with sauron

First, install Git. Most Linux distribution provide Git as a package.

On the system you choose to burden with the task of checking on the others'
disk space:

    include sauron::server

in Hiera, where your server node will pick it up:

~~~ yaml
    sauron::server::config:
        notify:
            - kermit@muppets.domain
~~~

On the systems to be monitored:

    include sauron

From then on, you will get reports by email (provided your name is Kermit) on
disk and inode usage by default thresholds, whenever the situation of any one
local partition (ext4,...) on a client changes.

## Usage

### Server side configuration

The global configuration can be customised.

The hash structure under `sauron::server::config` (which is looked up in Hiera using a deep hash merge) is translated litterally in the global config file in /etc/sauron/diskspace. Anything you put there will override or extend the default. 

A slightly more extensive configuration could be:

~~~ yaml
sauron::server::config:
    email:
        enabled: true
        server: smtp.your-isp.net
    notify:
        - kermit@muppets.domain
    thresholds:
      /var/lib/mysql:
        info: 60
        notice: 70
        warning: 80
        critical: 90
~~~

In this case, your email will be delivered directly by SMTP and the thresholds
for the partition where your MySQL server's data lives will be considerably
lower.

For a full reference, see: https://github.com/flyingrocket/sauron/blob/master/config/example.config.yaml

### Client side configuration

Configuration can also be customized on a per-node basis. By default, each
client node will get an entry in the services config file with no specific
configuration. 

The per client configuration supports much of the same directives as the global
one. Once again, for full reference: https://github.com/flyingrocket/sauron/blob/master/config/example.services.yaml

This structure goes under the eye of Sauron:

Include this data structure in your Hiera hierarchy, where it applies to a node
to be monitored. In this example, we set a low bar for Grommit to complain about
disk space exceeding 3 quarters of a partition:

~~~ yaml
sauron::eye:
    notify:
        - grommit@muppets.domain
    thresholds:
        default:
            notice: 90
            info: 75
~~~


## Reference

* server manifest parameters:
  * `appversion` - Git tag, branch, or revision of Sauron to checkout 
  * `ensure` - sets presence of application code, cron job, and config files
  * `config` - global config file
* main manifest parameters:
  * `ensure` - presence of user and whether node shows up in services file
  * `services_file` - aforementioned file listing nodes and their configuration
  * `eye` - client specific configuration explained [above](#client-side-configuration)

## Limitations

Does not configure the ssh login for the sauron user. But there is always the
sshkeys module!

There is no possibility to define multiple Sauron jobs, despite being able to
configure the file names of the config and services file.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
