#!/usr/bin/bash

mkdir /home/centos/temp
cd /home/centos/temp
sudo wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
tar -xvf mysql-connector-java-5.1.46.tar.gz
sudo mkdir -p /usr/share/java/
sudo cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar

sudo yum install cloudera-manager-daemons cloudera-manager-server cloudera-manager-agent -y
sleep 10
sudo /usr/share/cmf/schema/scm_prepare_database.sh mysql -h localhost -uroot -pcdh1234 -P 3306 scm scm scm >> /home/centos/statusOfMaria
sleep 10
sudo service cloudera-scm-server start
sudo service cloudera-scm-agent start
# sudo service mariadb start
touch /home/centos/_SetupCmComplete_
