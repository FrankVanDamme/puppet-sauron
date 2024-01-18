class sauron::server::app (
    $appsource,
    $appversion,
    $ensure,
) inherits sauron::params {
    # program code
    vcsrepo { "/home/sauron/bin/sauron2":
        ensure   => $ensure,
        provider => git,
        source   => $appsource,
        revision => $appversion,
        owner    => "sauron",
    }
}
