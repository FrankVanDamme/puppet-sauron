class sauron::server::config () inherits sauron::server {
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

    file { 
        [ 
            "/home/sauron/sauron2.d", 
            "/home/sauron/bin", 
            "/home/sauron/sauron2.d/logs", 
            "/home/sauron/sauron2.d/tmp" ] :
        ensure => $ensure_dir,
        owner  => "sauron",
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
}
