#!/bin/bash
yum install httpd php mysql php-mysql mysql-server wget rsyslog rsyslog-mysql
chkconfig --add rsyslog
chkconfig --add mysqld
chkconfig --add httpd
chkconfig rsyslog on
chkconfig httpd on
chkconfig mysqld on
service rsyslog start
service mysqld start
service httpd start
mysqladmin -u root password studentnetsys1
mysql -u root -p "studentnetsys1" < /usr/share/doc/rsyslog-mysql-4.6.2/createDB.sql
mysql -u root -p "studentnetsys1" -e 'GRANT ALL ON Syslog.* TO rsyslog@localhost IDENTIFIED BY "studentnetsys1" \ flush privileges \ exit; '
sed -i '1i#### Module ####\n
2i$ModLoad imuxsock \n 
3i$ModLoad imklog \n
4i#$ModLoad immark \n
5i$ModLoad ommysql \n
6i$ModLoad imudp \n
7i$UDPServerRun 514 \n
8i$ModLoad imtcp \n
9i$InputTCPServerRun 514 \n
10i$ModLoad ommail \n
11i$ModLoad ommysql \n
12iauthpriv.* :ommysql:127.0.0.1,Syslog,rsyslog,studentnetsys1 \n' /etc/rsyslog.conf
chkconfig syslog off
service syslog stop
chkconfig rsyslog on
service rsyslog start
cd ~
wget http://download.adiscon.com/loganalyzer/loganalyzer-3.4.3.tar.gz
tar -zxvf loganalyzer-3.4.3.tar.gz
mv loganalyzer-3.4.3/src /var/www/html/loganalyzer
mv loganalyzer-3.4.3/contrib/* /var/www/html/loganalyzer/
cd /var/www/html/loganalyzer
chmod u+x configure.sh secure.sh
./configure.sh

