#!/usr/bin/bash

sudo yum update -y
sudo yum install wget -y

# User Creation
sudo adduser maruthiprithivi \
&& sudo echo "maruthiprithivi:maruthiprithivi" | chpasswd \
&& sudo groupadd test \
&& sudo usermod -g test maruthiprithivi \
&& sudo usermod -g test centos

#Setup YUM repo
cd /etc/yum.repos.d/
sudo wget http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo
sudo sed -i "s/^baseurl\=http:\/\/archive\.cloudera\.com\/director\/redhat\/7\/x86_64\/director\/2\/$/baseurl\=http:\/\/archive\.cloudera\.com\/director\/redhat\/7\/x86_64\/director\/2.7.1\//" /etc/yum.repos.d/cloudera-director.repo
sudo wget http://archive.cloudera.com/director/redhat/7/x86_64/director/cloudera-director.repo
sudo sed -i "s/^baseurl\=https:\/\/archive\.cloudera\.com\/cm5\/redhat\/7\/x86_64\/cm\/5\/$/baseurl\=http:\/\/archive\.cloudera\.com\/cm5\/redhat\/7\/x86_64\/cm\/5.14.3\//" /etc/yum.repos.d/cloudera-manager.repo

sudo yum install oracle-j2sdk1.8 -y

# sudo echo "export PATH=$PATH:/usr/java/jdk1.8.0_121-cloudera/bin/" >> /home/centos/.bashrc
# sudo echo "export JAVA_HOME=/usr/java/jdk1.8.0_121-cloudera/bin/" >> /home/centos/.bashrc
sudo yum install bind-utils -y
sudo yum install nscd -y
sudo systemctl start nscd.service
sudo systemctl enable nscd.service
sudo echo "systemctl start nscd.service" >> /home/centos/.bashrc
sudo echo "sudo systemctl enable nscd.service" >> /home/centos/.bashrc
sudo yum install ntp -y
sudo systemctl start ntpd
sudo systemctl enable ntpd
sudo echo "sudo systemctl start ntpd" >> /home/centos/.bashrc
sudo echo "sudo systemctl enable ntpd" >> /home/centos/.bashrc
sudo echo "sudo service mariadb start" >> /home/centos/.bashrc
sudo yum install mariadb-server -y
sudo service mariadb stop

sudo echo "vm.swappiness = 1" >> /etc/sysctl.conf
sudo echo "NETWORKING_IPV6=no" >> /etc/sysctl.conf
sudo echo "IPV6INIT=no" >> /etc/sysctl.conf
sudo echo "transparent_hugepage=never" >> /etc/grub.conf
sudo echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /home/centos/.bashrc
sudo chmod 666 /sys/kernel/mm/transparent_hugepage/enabled
source ~/.bashrc
sudo cp /etc/my.cnf /etc/my.cnf.baks
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
&& sudo echo "server-id = 2" >> /etc/my.cnf \
&& sudo echo "replicate-ignore-db=mysql" >> /etc/my.cnf \
&& sudo echo "replicate-ignore-db=information_schema" >> /etc/my.cnf \
&& sudo echo "replicate-ignore-db=performance_schema" >> /etc/my.cnf \
&& sudo echo "relay-log = /var/log/mariadb/mariadb-relay-bin.log" >> /etc/my.cnf

mkdir /home/centos/temp
cd /home/centos/temp
sudo wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
tar -xvf mysql-connector-java-5.1.46.tar.gz
sudo mkdir -p /usr/share/java/
sudo cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar
sudo service mariadb start
sudo /usr/bin/mysql_secure_installation
