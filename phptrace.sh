cd ~
set -o errexit

if hash git; then
	git clone https://github.com/Qihoo360/phptrace
else
	echo "Pls install git! " && exit;
fi

# 1. install phptrace extension
cd phptrace/phpext
phpize
./configure 
make
sudo make install
phpini=`php -i |grep -o -E 'Configuration File => [^[:space:]]+php\.ini' | awk '{print $4}'`
[[ -z $phpini ]] && echo 'Could not find php.ini!' && exit;
extension_dir=`php -i | grep -o -E "^extension_dir => [^[:space:]]+" | awk '{print $3}'`
[[ -z $extension_dir ]] && echo 'Could not find extension_dir!' && exit;

cat <<-MM | sudo tee -a $phpini
	[phptrace]
	extension=$extension_dir/phptrace.so
	phptrace.enabled=1

MM

# 2. compile phptrace cli tool
cd ../cmdtool && make
[[ -d ~/bin ]] || mkdir ~/bin
cp {phptrace,trace-php} ~/bin

cat <<-MM
	The phptrace cli tool and its phptrace extension are successfully installed!
	Usage:
		phptrace -p <fpm's pid>
MM
cd ~
