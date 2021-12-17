class sauron::server::config (
    $appversion        = $sauron::params::appversion,
    $threshold_info    = $sauron::params::threshold_info,
    $threshold_notice  = $sauron::params::threshold_notice,
    $threshold_warning = $sauron::params::threshold_warning,
    $threshold_critical= $sauron::params::threshold_critical,
    $ensure            = $sauron::params::ensure,
    $services_file     = $sauron::params::services_file,
    $config_file       = $sauron::params::config_file,
    $config            = $sauron::params::config,
    $saurontag         = $sauron::params::saurontag, 
) inherits sauron::params {
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

    $config_ = deep_merge ( $::sauron::params::config, hiera_hash ( 'sauron::server::config', {} ) )
    file { $config_file:
    	content => hash2yaml($config_),
    	ensure  => $ensure,
    }

    Concat::Fragment <<| target  == "$::sauron::services_file" and tag == "$saurontag" |>>
    concat { "$::sauron::services_file":
        ensure => $ensure,
    }
}
