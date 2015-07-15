#######################
# Only support centos6
##############
# libmcrypt
## RHEL/CentOS 6 64-Bit ##
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm
cd;

# gcc
yum -y install gcc gcc-c++ glibc automake autoconf libtool make
yum -y install libmcrypt-devel mhash-devel libxslt-devel \
libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel \
zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel \
ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel \
krb5 krb5-devel libidn libidn-devel openssl openssl-devel

# compile
wget http://php.net/distributions/php-5.6.11.tar.bz2
tar xjf php-5.6.11.tar.bz2
cd php-5.6.11/

# configure
./configure --prefix=/usr/local/php --enable-fpm --with-mcrypt \
--enable-mbstring --disable-pdo --with-curl --disable-debug --disable-rpath \
--enable-inline-optimization --with-bz2 --with-zlib --enable-sockets \
--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex \
--with-mhash --enable-zip --with-pcre-regex --with-mysql --with-mysqli \
--with-gd --with-jpeg-dir --disable-fileinfo

# --disable-fileinfo " for small memory less than 1G

# make && make install
make all install

# config
## --with-config-file-path=/usr/local/php/lib
cp php.ini-development /usr/local/php/lib/php.ini
ln -s /usr/local/php/lib/php.ini /etc/
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
ln -s /usr/local/php/etc/php-fpm.conf /etc/

PATH+=:/usr/local/php/bin:/usr/local/php/sbin
