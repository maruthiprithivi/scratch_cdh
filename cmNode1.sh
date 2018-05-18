#!/usr/bin/bash

sudo yum update -y
sudo yum install wget -y

# Test user
# sudo adduser maruthiprithivi \
# && sudo echo "maruthiprithivi:maruthiprithivi" | chpasswd \
# && sudo groupadd test \
# && sudo usermod -g test maruthiprithivi \
# && sudo usermod -g test centos \
# && sudo usermod -aG wheel maruthiprithivi

# Disable SELINUX
sudo sed -i "s/^SELINUX\=enforcing/SELINUX\=disabled/" /etc/selinux/config

sudo echo "vm.swappiness = 1" >> /etc/sysctl.conf

#Setup YUM repo
cd /etc/yum.repos.d/
sudo wget http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo
sudo wget http://archive.cloudera.com/director/redhat/7/x86_64/director/cloudera-director.repo
sudo sed -i "s/^baseurl\=http:\/\/archive\.cloudera\.com\/director\/redhat\/7\/x86_64\/director\/2\/$/baseurl\=http:\/\/archive\.cloudera\.com\/director\/redhat\/7\/x86_64\/director\/2.7.1\//" /etc/yum.repos.d/cloudera-director.repo
sudo sed -i "s/^baseurl\=https:\/\/archive\.cloudera\.com\/cm5\/redhat\/7\/x86_64\/cm\/5\/$/baseurl\=http:\/\/archive\.cloudera\.com\/cm5\/redhat\/7\/x86_64\/cm\/5.11.2\//" /etc/yum.repos.d/cloudera-manager.repo

#MariaDB Repo
# sudo echo "# MariaDB 10.0 RedHat repository list - created 2018-05-17 22:55 UTC" >> /etc/yum.repos.d/mariadb.repo \
# && sudo echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/mariadb.repo \
# && sudo echo "[mariadb]" >> /etc/yum.repos.d/mariadb.repo \
# && sudo echo "name = MariaDB" >> /etc/yum.repos.d/mariadb.repo \
# && sudo echo "baseurl = http://yum.mariadb.org/10.0/rhel7-amd64" >> /etc/yum.repos.d/mariadb.repo \
# && sudo echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/mariadb.repo \
# && sudo echo "gpgcheck=1" >> /etc/yum.repos.d/mariadb.repo

sudo yum clean all
sudo yum install oracle-j2sdk1.8 -y

# sudo echo "export PATH=$PATH:/usr/java/jdk1.8.0_121-cloudera/bin/" >> /home/centos/.bashrc
# sudo echo "export JAVA_HOME=/usr/java/jdk1.8.0_121-cloudera/bin/" >> /home/centos/.bashrc
sudo yum install bind-utils -y
sudo yum install nscd -y
sudo systemctl start nscd.service
sudo systemctl enable nscd.service
sudo echo "sudo systemctl start nscd.service" >> /home/centos/.bashrc
sudo echo "sudo systemctl enable nscd.service" >> /home/centos/.bashrc
sudo yum install ntp -y
sudo systemctl start ntpd
sudo systemctl enable ntpd
sudo echo "sudo systemctl start ntpd" >> /home/centos/.bashrc
sudo echo "sudo systemctl enable ntpd" >> /home/centos/.bashrc
sudo echo "sudo service mariadb restart" >> /home/centos/.bashrc
# To install from MariaDB Repo
# sudo yum install MariaDB-server -y
# To install from centos base
sudo yum install mariadb-server -y
sudo service mariadb stop


sudo echo "vm.swappiness = 1" >> /etc/sysctl.conf
sudo echo "NETWORKING_IPV6=no" >> /etc/sysctl.conf
sudo echo "IPV6INIT=no" >> /etc/sysctl.conf
# sudo echo "transparent_hugepage=never" >> /etc/grub.conf
# sudo echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /home/centos/.bashrc
# sudo chmod 666 /sys/kernel/mm/transparent_hugepage/enabled
# source ~/.bashrc

sudo echo "[Unit]" >> /etc/systemd/system/disable-thp.service \
&& sudo echo "Description=Disable Transparent Huge Pages (THP)" >> /etc/systemd/system/disable-thp.service \
&& sudo echo "[Service]" >> /etc/systemd/system/disable-thp.service \
&& sudo echo "Type=simple" >> /etc/systemd/system/disable-thp.service \
&& sudo echo 'ExecStart=/bin/sh -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled && echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag"' >> /etc/systemd/system/disable-thp.service \
&& sudo echo "[Install]" >> /etc/systemd/system/disable-thp.service \
&& sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/disable-thp.service
sudo systemctl daemon-reload
sudo systemctl start disable-thp
sudo systemctl enable disable-thp
sudo cp /etc/my.cnf /etc/my.cnf.bak
sudo echo "[mysqld]" > /etc/my.cnf \
&& sudo echo "transaction-isolation = READ-COMMITTED" >> /etc/my.cnf \
&& sudo echo "key_buffer = 16M" >> /etc/my.cnf \
&& sudo echo "key_buffer_size = 32M" >> /etc/my.cnf \
&& sudo echo "max_allowed_packet = 32M" >> /etc/my.cnf \
&& sudo echo "thread_stack = 256K" >> /etc/my.cnf \
&& sudo echo "thread_cache_size = 64" >> /etc/my.cnf \
&& sudo echo "query_cache_limit = 8M" >> /etc/my.cnf \
&& sudo echo "query_cache_size = 64M" >> /etc/my.cnf \
&& sudo echo "query_cache_type = 1" >> /etc/my.cnf \
&& sudo echo "max_connections = 550" >> /etc/my.cnf \
&& sudo echo "log_bin=/var/lib/mysql/mysql_binary_log" >> /etc/my.cnf \
&& sudo echo "binlog_format = mixed" >> /etc/my.cnf \
&& sudo echo "read_buffer_size = 2M" >> /etc/my.cnf \
&& sudo echo "read_rnd_buffer_size = 16M" >> /etc/my.cnf \
&& sudo echo "sort_buffer_size = 8M" >> /etc/my.cnf \
&& sudo echo "join_buffer_size = 8M" >> /etc/my.cnf \
&& sudo echo "innodb_file_per_table = 1" >> /etc/my.cnf \
&& sudo echo "innodb_flush_log_at_trx_commit  = 2" >> /etc/my.cnf \
&& sudo echo "innodb_log_buffer_size = 64M" >> /etc/my.cnf \
&& sudo echo "innodb_buffer_pool_size = 4G" >> /etc/my.cnf \
&& sudo echo "innodb_thread_concurrency = 8" >> /etc/my.cnf \
&& sudo echo "innodb_flush_method = O_DIRECT" >> /etc/my.cnf \
&& sudo echo "innodb_log_file_size = 512M" >> /etc/my.cnf \
&& sudo echo "[mysqld_safe]" >> /etc/my.cnf \
&& sudo echo "log-error=/var/log/mariadb/mariadb.log" >> /etc/my.cnf \
&& sudo echo "pid-file=/var/run/mariadb/mariadb.pid" >> /etc/my.cnf \
&& sudo echo "server-id = 1" >> /etc/my.cnf \
&& sudo echo "replicate-ignore-db=mysql" >> /etc/my.cnf \
&& sudo echo "replicate-ignore-db=information_schema" >> /etc/my.cnf \
&& sudo echo "replicate-ignore-db=performance_schema" >> /etc/my.cnf

# sudo echo "<property>" \ >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml \
# && sudo echo "  <name>dfs.permissions.superusergroup</name>" >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml \
# && sudo echo "  <value>test</value>" >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml \
# && sudo echo "</property>" >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml

sudo service mariadb start
# This will be an interactive passwprd setup
sudo /usr/bin/mysql_secure_installation
# Change the username and password based on your setup
mysql -uroot -pcdh1234 -e "create database amon DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "create database rman DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "create database metastore DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "create database sentry DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "create database nav DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "create database navms DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "create database oozie DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "create database hue DEFAULT CHARACTER SET utf8;" \
&& mysql -uroot -pcdh1234 -e "grant all on amon.* TO 'amon'@'%' IDENTIFIED BY 'amon_password';" \
&& mysql -uroot -pcdh1234 -e "grant all on rman.* TO 'rman'@'%' IDENTIFIED BY 'rman_password';" \
&& mysql -uroot -pcdh1234 -e "grant all on metastore.* TO 'hive'@'%' IDENTIFIED BY 'hive_password';" \
&& mysql -uroot -pcdh1234 -e "grant all on sentry.* TO 'sentry'@'%' IDENTIFIED BY 'sentry_password';" \
&& mysql -uroot -pcdh1234 -e "grant all on nav.* TO 'nav'@'%' IDENTIFIED BY 'nav_password';" \
&& mysql -uroot -pcdh1234 -e "grant all on navms.* TO 'navms'@'%' IDENTIFIED BY 'navms_password';" \
&& mysql -uroot -pcdh1234 -e "grant all on oozie.* TO 'oozie'@'%' IDENTIFIED BY 'oozie_password';" \
&& mysql -uroot -pcdh1234 -e "grant all on hue.* TO 'hue'@'%' IDENTIFIED BY 'hue_password';"
touch /home/centos/_SetupCmHalfwayThere_
init 6
