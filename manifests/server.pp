# Server side class: include on node(s) that run(s) Sauron
class sauron::server (
    String $appversion          = $sauron::params::appversion,
    String $ensure              = $sauron::params::ensure,
    Hash   $config              = $sauron::params::config,
    String $saurontag           = $sauron::params::saurontag,
    Hash $cron_diskspace_params = {},
    Hash $cron_inode_params     = {},
) inherits sauron::params {

    include sauron

    include sauron::server::skeleton

    class { "sauron::server::config":
        appversion         => $appversion,
        threshold_info     => $threshold_info,
        threshold_notice   => $threshold_notice,
        threshold_warning  => $threshold_warning,
        threshold_critical => $threshold_critical,
        ensure             => $ensure,
        services_file      => $services_file,
        config_file        => $config_file,
        config             => $config,
        saurontag          => $saurontag,
    }

    class { "sauron::server::cron":
        config_file      => $config_file,
        ensure           => $ensure,
        diskspace_params => $cron_diskspace_params,
        inode_params     => $cron_inode_params,
    }

    class { "sauron::server::app":
        appversion => $appversion,
        ensure     => $ensure,
    }
}
