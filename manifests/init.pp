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
    $whitelist = undef,
    Integer $threshold_info     = $sauron::params::threshold_info,
    Integer $threshold_notice   = $sauron::params::threshold_notice,
    Integer $threshold_warning  = $sauron::params::threshold_warning,
    Integer $threshold_critical = $sauron::params::threshold_critical,
    String $whitelist_file      = $sauron::params::whitelist_file,
    String $server_file         = $sauron::params::server_file,
    $ensure                     = $sauron::params::ensure,
) inherits sauron::params {

    user { "sauron":
	ensure => $ensure,
	system => true,
    }

    @@concat::fragment { "sauron_server_$::fqdn":
	target  => $server_file,
	content => "$::fqdn\n",
	#tag     => $sectname,
	#order   => "${sectname}1",
    }

    if ( $whitelist != undef ){
	@@concat::fragment { "sauron_whitelist_$::fqdn":
	    target   => $whitelist_file, 
	    content  => "$::fqdn $whitelist",
	}
    }

}
