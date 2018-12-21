class sauron::server (
    String $ensure = $sauron::params::ensure,
    Hash   $config = $sauron::params::config,
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

    $f=lookup ( 'sauron::server::config', Hash, deep, {} )
    notify { "f: $f; defaultconfig: $::sauron::params::config": }

    $config_ = deep_merge ( $::sauron::params::config, hiera_hash ( 'sauron::server::config', {} ) )
    file { $config_file:
    	content => hash2yaml($config_),
    	ensure  => $ensure,
    }

    Concat::Fragment <<| target  == "$::sauron::services_file" |>>
    concat { "$::sauron::services_file": }

    cron { "sauron":
	command => "/home/sauron/bin/sauron2/sauron.py -c $config_file -s $::sauron::services_file", 
	minute  => "*/5",
	hour    => "*",
	ensure  => $ensure,
	user    => "sauron",
    }
}
