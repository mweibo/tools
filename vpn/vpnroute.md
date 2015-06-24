vpnroute.tgz 用于vpn 自动路由，iplist 中的ip 不走vpn, 否则则走vpn

	#1. vpnroute.tgz 里面有三个文件, 拷贝到mac 下的/etc/ppp/ 目录：
	sudo cp {ip-up,ip-down,iplist} /etc/ppp

	#2. 增加可执行权限即可:
	sudo chmod a+x /etc/ppp/{ip-up,ip-down,iplist}

iplist 里面罗列的ip 都不走vpn, 通常公司内网的ip 是不走外网的(即不能走vpn 访问)，所以你需要将公司ip 加入到iplist	
比如你公司的内网ip 段是：`10.10.10.*`, 那可以在iplist 中添加一条(多个ip 段就换行写):

	10.10.10.0/24
