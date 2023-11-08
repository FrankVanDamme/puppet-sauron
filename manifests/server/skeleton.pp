# Creates directories
class sauron::server::skeleton (
) inherits sauron::params {
    $ensure_dir = $ensure? {
        present => directory,
        default => $ensure,
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
}
