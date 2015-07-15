# rsync
yum -y install rsync
rsyncfile=/etc/rsyncd.conf ;
if ! grep -F '[blog]' $rsyncfile >/dev/null ; then
	cat <<-MM | sudo tee -a $rsyncfile

		[blog]
		uid = hilo
		hosts allow = 10.0.0.0/16
		hosts deny  = *
		read only   = false
		list        = false
		path        = /path/to/site
	MM
fi

sudo rsync --daemon --config=$rsyncfile --port=873
#chkconfig rsync on
#service xinetd restart
