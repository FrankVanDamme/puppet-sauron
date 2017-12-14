class sauron::server (
    $recipients ,
) inherits sauron::params {
    include sauron
    file { "/etc/sauron":
	ensure => directory,
    }

    file { "/etc/sauron/sauron.cfg":
	content => template("$module_name/sauron.cfg.erb"),
    } 

    Concat::Fragment <<| target  == "$::sauron::server_file" |>>
    concat { "$::sauron::server_file": }

    Concat::Fragment <<| target  == "$::sauron::whitelist_file" |>>
    concat { "$::sauron::whitelist_file": }

    cron { "sauron":
	command => "/opt/maintenance-scripts/sauron/check.diskspace.sh > /dev/null", 
	minute  => "*/5",
	hour    => "*",
    }
}
