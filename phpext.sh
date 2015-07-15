####################################################
# This script is used to install php extension.
# Require: wget.
# Support: supports centos, fedora, redhat, macosx.
# Author: hilojack.com
# Usage: sh <(wget https://raw.githubusercontent.com/hilojack/php-lib/master/app/phpext.sh -O -) phptrace
####################################################
cd ~
set -o errexit;
[[ -z "$1" ]] && exit;
php -m | grep -F "$1" && echo "Warning: you have installed $1 before!" && exit;
if ! php -m | grep $1 > /dev/null; then
	phpini=`php --ini | grep -o -E 'Configuration File:\s+\S+php\.ini' | awk '{print $3}'`
	[[ -z $phpini ]] && echo 'Could not find php.ini!' && exit;
	extension_dir=`php -i | grep -o -E "^extension_dir => \S+" | awk '{print $3}'`
	[[ -z $extension_dir ]] && echo 'Could not find extension_dir!' && exit;

	source <(wget https://raw.githubusercontent.com/hilojack/php-lib/master/app/$1.sh -O -)

	if hash service; then
		sudo service php-fpm restart;
	else
		sudo pkill php-fpm;
		sudo php-fpm -D;
	fi
fi
cd ~
