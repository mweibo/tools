####################################################
# This script is used to install xhprof extension.
# Require: wget.
# Support: supports centos, fedora, redhat, macosx.
# Author: hilojack.com
####################################################
cat <<'MM'
# The code below is used to create xhprof data:
xhprof_enable(XHPROF_FLAGS_CPU + XHPROF_FLAGS_MEMORY);
ob_start(function($buf){
	$xhprof_data = xhprof_disable();
	$XHPROF_ROOT = '/tmp/xhprof';
	include_once $XHPROF_ROOT . "/xhprof_lib/utils/xhprof_lib.php";
	include_once $XHPROF_ROOT . "/xhprof_lib/utils/xhprof_runs.php";
	$source = 'xhprof_debug';
	$run_id = (new XHProfRuns_Default())->save_run($xhprof_data, $source);
	$url = "http://{$_SERVER['SERVER_ADDR']}:8000/index.php?run={$run_id}&source=$source";
	$link =  "<a href='$url'> $url</a><br>";
	return $link . $buf;
});
MM

if ! php -m | grep xhprof > /dev/null; then
	cd ~;
	wget http://pecl.php.net/get/xhprof-0.9.4.tgz -O - | tar xzvf -
	cd xhprof-0.9.4/extension/
	phpize
	./configure
	make && sudo make install
	sudo mkdir /tmp/xhprof
	sudo chmod 777 /tmp/xhprof/

	phpini=`php --ini | grep -o -E 'Configuration File:\s+\S+php\.ini' | awk '{print $3}'`
	[[ -z $phpini ]] && echo 'Could not find php.ini!' && exit;
	extension_dir=`php -i | grep -o -E "^extension_dir => \S+" | awk '{print $3}'`
	[[ -z $extension_dir ]] && echo 'Could not find extension_dir!' && exit;

	cat <<-MM | sudo tee -a $phpini

		[xhprof]
		extension = xhprof.so
		xhprof.output_dir = "/tmp/xhprof"
	MM

	mv ~/xhprof-0.9.4/xhprof_lib/ /tmp/xhprof/
	mv ~/xhprof-0.9.4/xhprof_html/ /tmp/xhprof/
	#ownip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
	nohup php -S 0.0.0.0:8000 -t /tmp/xhprof/xhprof_html/ &
	sudo yum install graphviz -y || brew install graphviz; # xhprof's callgraph rely on graphviz

	if hash service; then
		sudo service php-fpm restart;
	else
		sudo pkill php-fpm;
		sudo php-fpm -D;
	fi
fi
