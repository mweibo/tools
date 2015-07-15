# for centos
sudo yum install ctags -y
cd ~
wget http://home.tiscali.cz/~cz210552/distfiles/webbench-1.5.tar.gz -O - | tar xzvf -
cd webbench-1.5
make && sudo make install
