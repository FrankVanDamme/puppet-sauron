class sauron::server (
    String $appversion = $sauron::params::appversion,
    String $ensure     = $sauron::params::ensure,
    Hash   $config     = $sauron::params::config,
) inherits sauron::params {

    include sauron

    class { "sauron::server::config":
        $appversion         => $appversion,
        $threshold_info     => $threshold_info,
        $threshold_notice   => $threshold_notice,
        $threshold_warning  => $threshold_warning,
        $threshold_critical => $threshold_critical,
        $ensure             => $ensure,
        $services_file      => $services_file,
        $config_file        => $config_file,
        $eye                => $eye,
        $config             => $config,
    }

    class { "sauron::server::cron":
        $config => $config,
    }

    class { "sauron::server::app":
        $appversion,
    }
}
