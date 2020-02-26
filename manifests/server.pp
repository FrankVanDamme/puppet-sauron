class sauron::server (
    String $appversion = $sauron::params::appversion,
    String $ensure     = $sauron::params::ensure,
    Hash   $config     = $sauron::params::config,
) inherits sauron::params {

    include sauron

    include sauron::server::config
    include sauron::server::cron
    include sauron::server::app
}
