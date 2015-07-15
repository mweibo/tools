##################################################
## Install xdebug extension
## Require: GNU grep >= 2.6.1 or BSD grep >= 2.5.1
## Author: hilojack.com
################################################
cd ~
set -o errexit

php -m | grep xdebug > /dev/null && exit;

if hash git1234; then
	git clone https://github.com/derickr/xdebug 
else
	wget http://xdebug.org/files/xdebug-2.3.2.tgz -O - | tar xzf -
	mv xdebug-2.3.2 xdebug
fi
cd xdebug
phpize
./configure --enable-xdeubg
make
sudo make install
#phpini=`php -i |grep -o -E 'Configuration File => [^[:space:]]+php\.ini' | awk '{print $4}'`
phpini=`php --ini | grep -o -E 'Configuration File:\s+\S+php\.ini' | awk '{print $3}'`
[[ -z $phpini ]] && echo 'Could not find php.ini!' && exit;
extension_dir=`php -i | grep -o -E "^extension_dir => \S+" | awk '{print $3}'`
[[ -z $extension_dir ]] && echo 'Could not find extension_dir!' && exit;

#cat >> $phpini <<-MM
cat <<-MM | sudo tee -a $phpini
	[xdebug]
	zend_extension=$extension_dir/xdebug.so
	;通过GET/POST/COOKIE:传XDEBUG_PROFILE触发
	xdebug.profiler_enable_trigger=1
	;通过GET/POST/COOKIE:传XDEBUG_TRACE触发
	xdebug.trace_enable_trigger=1
	;xdebug.profiler_output_dir="/tmp"
	;full variable contents and variable name
	xdebug.trace_output_name="trace"
	xdebug.profiler_output_name="callgrind.out"
	xdebug.collect_params=4
	xdebug.show_mem_delta=1
	html_errors=0

	;remote xdebug
	xdebug.remote_connect_back=1
	;xdebug.remote_host=10.9.12.0
	xdebug.remote_port=9000
	xdebug.remote_enable=on
MM
if hash service; then
	sudo service php-fpm restart;
else
	sudo pkill php-fpm;
	sudo php-fpm -D;
fi
cd ~
