# install vsftpd
if ! pgrep vsftpd ; then
	sudo yum install vsftpd -y
	sudo sed -i 's/^anonymous_enable=YES/anonymous_enable=NO/' /etc/vsftpd/vsftpd.conf
	sudo sed -i 's/^#local_enable=/local_enable=/' /etc/vsftpd/vsftpd.conf
	sudo sed -i 's/^#write_enable=YES/write_enable=YES/' /etc/vsftpd/vsftpd.conf
	sudo sed -i 's/^one_process_model=/#one_process_model=/' /etc/vsftpd/vsftpd.conf
	sudo sed -i 's/^#local_umask=022/local_umask=022/' /etc/vsftpd/vsftpd.conf
	sudo service vsftpd restart
fi
