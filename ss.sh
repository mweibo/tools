# This script is used to install shadowsocks server.
# It only supports banwagon's centos vps. 
#  	Default encrypt algorithm: aes-256-cfb
#  	Default port: 10086
#

function iptables_set(){
	port=$1;
	echo "iptables start setting..."
	/sbin/service iptables status 1>/dev/null 2>&1
	if [ $? -eq 0 ]; then
		/etc/init.d/iptables status | grep -F $port | grep 'ACCEPT' >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			/sbin/iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $port -j ACCEPT
			/etc/init.d/iptables save
			/etc/init.d/iptables restart
		else
			echo "port $port has been set up."
		fi
	else
		echo "iptables looks like shutdown, please manually set it if necessary."
	fi
}

yum install git bzip2 openssl-devel  build-essential autoconf libtool gcc make -y
git clone https://github.com/madeye/shadowsocks-libev.git
cd shadowsocks-libev/
./configure && make && make install

# https://github.com/shadowsocks/shadowsocks-libev#usage
# https://github.com/shadowsocks/shadowsocks
# Default encrypt: table, you could choose other encrypt algorithm such as: aes-256-cfb ....
# ip=`ifconfig | grep '^venet0:0' -A 1 |tail -n 1|awk '{print $2}' | grep -o -E '[[:digit:].]+'`
ip=0.0.0.0
port=10086
password=world
encryption=aes-256-cfb

#iptables_set $port

# nohup ss-server -s $ip -p $port -k $password -m table &
#/usr/bin/ssserver -p $port -k $password -m $encryption --user nobody --workers 2 -d start
ss="/usr/local/bin/ss-server -p $port -k $password -m $encryption --user nobody --workers 2 -d start"
echo "$ss" >> /etc/rc.d/rc.local;
eval "$ss &";
