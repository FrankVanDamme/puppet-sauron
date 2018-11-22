class sauron::params () {

    $threshold_info     = 87
    $threshold_notice   = 90
    $threshold_warning  = 94
    $threshold_critical = 97
    $ensure             = present
    $services_file      = "/etc/sauron/diskspace/puppet.services.yaml"
    $config_file        = "/etc/sauron/diskspace/puppet.config.yaml"
    $eye                = {}
    $config = {
	dirs => {
	  # directory where log files are kept
	  log => "/home/sauron/sauron2.d/logs",
	  # directory where tmp files are kept
	  tmp => "/home/sauron/sauron2.d/tmp",
	},
	# send mail
	email => {
	  enabled => true,
	  services => true,
	},
	# mounts which are ignored
	ignored => {} ,
	notify => [
	],
	ssh_timeout => "15",
	thresholds => {
	    "default" => {
	      info => 87,
	      notice => 90,
	      warning => 94,
	      critical => 97,
	    },
	}
    } 
}

