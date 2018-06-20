class sauron::server (
    String $ensure = $sauron::params::ensure,
    $recipients ,
) inherits sauron::params {
    include sauron

    $ensure_dir = $ensure? {
	present => directory,
	default => $ensure,
    }

    file { "/etc/sauron":
	ensure => $ensure_dir,
    }
    file { "/etc/sauron/diskspace":
	ensure => $ensure_dir,
    }

    file { "/etc/sauron/diskspace/config.cfg":
	content => template("$module_name/sauron.cfg.erb"),
	ensure  => $ensure,
    } 

    Concat::Fragment <<| target  == "$::sauron::server_file" |>>
    concat { "$::sauron::server_file": }

    Concat::Fragment <<| target  == "$::sauron::whitelist_file" |>>
    concat { "$::sauron::whitelist_file": }

    cron { "sauron":
	command => "/opt/maintenance-scripts/sauron/check.diskspace.sh -d /etc/sauron/diskspace > /dev/null", 
	minute  => "*/5",
	hour    => "*",
	ensure  => $ensure,
    }
}
