class sauron::server::app (
    $appversion,
) inherits sauron::params {
    # program code
    vcsrepo { "/home/sauron/bin/sauron2":
        ensure   => present,
        provider => git,
        source   => "https://github.com/flyingrocket/sauron.git",
        revision => $appversion,
        owner    => "sauron",
    }
}
