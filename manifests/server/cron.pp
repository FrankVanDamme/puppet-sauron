class sauron::server::cron () inherits sauron::server {
    cron { "sauron":
	command => "/home/sauron/bin/sauron2/sauron.py -c $config_file -s $::sauron::services_file > /home/sauron/sauron2.d/logs/`date +cron_\%a_\%H:\%M`", 
	minute  => "*/5",
	hour    => "*",
	ensure  => $ensure,
	user    => "sauron",
    }

    cron { "sauron_inodes":
	command => "/home/sauron/bin/sauron2/sauron.py -i -c $config_file -s $::sauron::services_file > /home/sauron/sauron2.d/logs/`date +cron_inodes_\%a_\%H:\%M`", 
	minute  => "0",
	hour    => "7",
	ensure  => $ensure,
	user    => "sauron",
    }
}
