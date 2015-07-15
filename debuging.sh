##################################################
## Install debuging
################################################
cd ~
set -o errexit

php -i | grep -F debuging.php > /dev/null && exit;

phpini=`php --ini | grep -o -E 'Configuration File:\s+\S+php\.ini' | awk '{print $3}'`
[[ -z $phpini ]] && echo 'Could not find php.ini!' && exit;

curl -s https://raw.githubusercontent.com/hilojack/php-lib/master/debuging.php > /tmp/debuging.php;
if [[ $1 = '-xhprof' ]];then
	wget https://raw.githubusercontent.com/hilojack/php-lib/master/app/xhprof.sh -O - | sh;
fi

#cat >> $phpini <<-MM
cat <<-MM | sudo tee -a $phpini
	[debuging]
	auto_prepend_file=/tmp/debuging.php
MM
if hash service; then
	sudo service php-fpm restart;
else
	sudo pkill php-fpm;
	sudo php-fpm -D;
fi
cd ~
