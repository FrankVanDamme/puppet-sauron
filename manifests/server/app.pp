class sauron::server::app () inherits sauron::server {
    # program code
    vcsrepo { "/home/sauron/bin/sauron2":
        ensure   => present,
        provider => git,
        source   => "https://github.com/flyingrocket/sauron.git",
        revision => $appversion,
        owner    => "sauron",
    }
}
