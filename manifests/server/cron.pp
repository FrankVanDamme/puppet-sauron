# Installs cron jobs to run sauron periodically
class sauron::server::cron (
    $config_file,
    $ensure,
    Hash $diskspace_params,
    Hash $inode_params,
) inherits sauron::params {

    $diskspace = {
        minute  => "*/5",
        hour    => "*",
        ensure  => $ensure,
        user    => "sauron",
    } + $diskspace_params

    $inodes = {
        minute  => "0",
        hour    => "7",
        ensure  => $ensure,
        user    => "sauron",
    } + $inode_params

    cron { "sauron":
        command => @("SAURON"/L)
        /home/sauron/bin/sauron2/sauron.py \
        -c ${config_file} -s ${::sauron::services_file} \
        > /home/sauron/sauron2.d/logs/`date +cron_\\%a_\\%H:\\%M`
        | SAURON
        ,
        *       => $diskspace,
    }

    cron { "sauron_inodes":
        command => @("SAURON"/L)
        /home/sauron/bin/sauron2/sauron.py -i \
        -c ${config_file} -s ${::sauron::services_file} \
        > /home/sauron/sauron2.d/logs/`date +cron_inodes_\\%a_\\%H:\\%M`
        | SAURON
        ,
        *       => $inodes,
    }
}
