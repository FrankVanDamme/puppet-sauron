class sauron::server::app (
    $appversion,
    $ensure,
) inherits sauron::params {
    # program code
    vcsrepo { "/home/sauron/bin/sauron2":
        ensure   => $ensure,
        provider => git,
        source   => "https://github.com/flyingrocket/sauron.git",
        revision => $appversion,
        owner    => "sauron",
    }
}
