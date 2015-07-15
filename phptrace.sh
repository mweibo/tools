if hash git; then
	git clone https://github.com/Qihoo360/phptrace
else
	echo "Please install git! " && exit;
fi

# 1. install phptrace extension
cd phptrace/extension
phpize
./configure && make && sudo make install

cat <<-MM | sudo tee -a $phpini

	[phptrace]
	extension=$extension_dir/trace.so
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
