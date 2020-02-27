class sauron::server::config (
    $appversion,
    $threshold_info,
    $threshold_notice,
    $threshold_warning,
    $threshold_critical,
    $ensure,
    $services_file,
    $config_file,
    $eye,
    $config,
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

    Concat::Fragment <<| target  == "$::sauron::services_file" |>>
    concat { "$::sauron::services_file": }
}
