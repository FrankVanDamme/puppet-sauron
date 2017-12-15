class sauron::server (
    $recipients ,
) inherits sauron::params {
    include sauron
    file { "/etc/sauron":
	ensure => directory,
    }
    file { "/etc/sauron/diskspace":
	ensure => directory,
    }

    file { "/etc/sauron/diskspace/config.cfg":
	content => template("$module_name/sauron.cfg.erb"),
    } 

    Concat::Fragment <<| target  == "$::sauron::server_file" |>>
    concat { "$::sauron::server_file": }

    Concat::Fragment <<| target  == "$::sauron::whitelist_file" |>>
    concat { "$::sauron::whitelist_file": }

    cron { "sauron":
	command => "/opt/maintenance-scripts/sauron/check.diskspace.sh -d /etc/sauron/diskspace > /dev/null", 
	minute  => "*/5",
	hour    => "*",
    }
}
