cd ~
set -o errexit

if hash git; then
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
phpini=`php -i |grep -o -E 'Configuration File => [^[:space:]]+php\.ini' | awk '{print $4}'`
[[ -z $phpini ]] && echo 'Could not find php.ini!' && exit;
extension_dir=`php -i | grep -o -E "^extension_dir => [^[:space:]]+" | awk '{print $3}'`
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
	xdebug.collect_params=4
	xdebug.show_mem_delta=1
	html_errors=0
MM
cd ~
