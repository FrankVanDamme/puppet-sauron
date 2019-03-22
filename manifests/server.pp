class sauron::server (
    String $appversion = $sauron::params::appversion,
    String $ensure     = $sauron::params::ensure,
    Hash   $config     = $sauron::params::config,
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

    file { 
        [ 
            "/home/sauron/sauron2.d", 
            "/home/sauron/bin", 
            "/home/sauron/sauron2.d/logs", 
            "/home/sauron/sauron2.d/tmp" ] :
        ensure => $ensure_dir,
        owner  => "sauron",
    }

    # program code
    vcsrepo { "/home/sauron/bin/sauron2":
        ensure   => present,
        provider => git,
        source   => "https://github.com/flyingrocket/sauron.git",
        revision => $appversion,
        owner    => "sauron",
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
	command => "/home/sauron/bin/sauron2/sauron.py -c $config_file -s $::sauron::services_file > /home/sauron/sauron2.d/logs/`date +cron_\%a_\%H:\%M`", 
	minute  => "*/5",
	hour    => "*",
	ensure  => $ensure,
	user    => "sauron",
    }

    cron { "sauron_inodes":
	command => "/home/sauron/bin/sauron2/sauron.py -i -c $config_file -s $::sauron::services_file > /home/sauron/sauron2.d/logs/`date +cron_inodes_\%a_\%H:\%M`", 
	minute  => "0",
	hour    => "7",
	ensure  => $ensure,
	user    => "sauron",
    }
}
