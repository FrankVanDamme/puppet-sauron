# Class: sauron
# ===========================
#
# Full description of class sauron here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'sauron':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#

class sauron (
    String  $ensure             = $sauron::params::ensure,
    String  $services_file      = $sauron::params::services_file,
    Hash    $eye                = $sauron::params::eye,
) inherits sauron::params {

    user { "sauron":
	ensure     => $ensure,
	system     => true,
	managehome => true,
    }

    $eye_ = hash2yaml({ $::fqdn => hiera_hash("sauron::eye", $eye) })

    @@concat::fragment { "sauron_services_$::fqdn":
	target  => $services_file,
	content => inline_template('<%= @eye_.sub(/^---$/, "")%>'),
    }
}
