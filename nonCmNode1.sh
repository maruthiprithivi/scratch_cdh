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


sudo yum install oracle-j2sdk1.8 -y

# sudo echo "export PATH=$PATH:/usr/java/jdk1.8.0_121-cloudera/bin/" >> /home/centos/.bashrc
# sudo echo "export JAVA_HOME=/usr/java/jdk1.8.0_121-cloudera/bin/" >> /home/centos/.bashrc
sudo yum install bind-utils -y
sudo yum install nscd -y
sudo systemctl start nscd.service
sudo systemctl enable nscd.service
sudo yum install ntp -y
sudo systemctl start ntpd
sudo systemctl enable ntpd
sudo yum install mysql -y

sudo echo "vm.swappiness = 1" >> /etc/sysctl.conf
sudo echo "NETWORKING_IPV6=no" >> /etc/sysctl.conf
sudo echo "IPV6INIT=no" >> /etc/sysctl.conf
# sudo echo "transparent_hugepage=never" >> /etc/grub.conf
# sudo echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /home/centos/.bashrc
# source /home/centos/.bashrc
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
sudo echo "bind-address=172.31.28.114" >> /etc/my.cnf

sudo echo "<property>" \ >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml \
&& sudo echo "  <name>dfs.permissions.superusergroup</name>" >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml \
&& sudo echo "  <value>test</value>" >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml \
&& sudo echo "</property>" >> /etc/hadoop/conf.cloudera.hdfs/core-site.xml

mkdir /home/centos/temp
cd /home/centos/temp
sudo wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
tar -xvf mysql-connector-java-5.1.46.tar.gz
sudo mkdir -p /usr/share/java/
sudo cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar

sudo init 6
