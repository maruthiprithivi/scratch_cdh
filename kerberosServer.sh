#!/usr/bin/bash
# Following steps from this wonderful blog
# https://blog.puneethabm.com/configure-hadoop-security-with-cloudera-manager-using-kerberos/

sudo yum -y install krb5-server krb5-libs krb5-auth-dialog krb5-workstation

sudo sed -i "s/EXAMPLE\.COM/ap-southeast-1\.compute\.internal/" /var/kerberos/krb5kdc/kdc.conf

sudo sed -i "12i  max_life = 1d" /var/kerberos/krb5kdc/kdc.conf \
&& sudo sed -i "13i  max_renewable_life = 7d" /var/kerberos/krb5kdc/kdc.conf

sudo sed -i "17i udp_preference_limit = 1" /etc/krb5.conf \
&& sudo sed -i "18i default_tgs_enctypes = arcfour-hmac" /etc/krb5.conf \
&& sudo sed -i "19i default_tkt_enctypes = arcfour-hmac" /etc/krb5.conf

sudo sed -i "s/^# \.example\.com = EXAMPLE\.COM/\.example\.com = ap-southeast-1\.compute\.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^# example\.com = EXAMPLE\.COM/\example\.com = ap-southeast-1\.compute\.internal/" /etc/krb5.conf

sudo sed -i "s/^# EXAMPLE\.COM/ ap-southeast-1\.compute\.internal/" /etc/krb5.conf \
# Needs editing
&& sudo sed -i "s/^#  kdc = kerberos\.example\.com/  kdc = ip-172-31-28-114\.ap-southeast-1\.compute\.internal/" /etc/krb5.conf \
# Needs editing
&& sudo sed -i "s/^#  admin_server = kerberos\.example\.com/  admin_server = ip-172-31-28-114\.ap-southeast-1\.compute.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^# }/ }/" /etc/krb5.conf

sudo sed -i "s/^# default_realm = EXAMPLE.COM/default_realm = ap-southeast-1\.compute\.internal/" /etc/krb5.conf

# Interactive
sudo /usr/sbin/kdb5_util create -s
#Interactive
sudo kadmin.local
# This is what i'm adding -> "addprinc cloudera-scm@ap-southeast-1.compute.internal" | password -> "cdh1234" | to exit -> "q"

# check this file to make sure that there is a space between the last "*" and the last word of the realm
sudo echo "*/admin@ap-southeast-1.compute.internal *" > /var/kerberos/krb5kdc/kadm5.acl
sudo echo "cloudera-scm@ap-southeast-1.compute.internal admilc" >> /var/kerberos/krb5kdc/kadm5.acl

#Interactive
sudo kadmin.local
# Do the following
# kadmin.local:  addpol admin
# kadmin.local:  addpol users
# kadmin.local:  addpol hosts
# kadmin.local:  xst -k cmf.keytab cloudera-scm@ap-southeast-1.compute.internal
# kadmin.local:  q

sudo mv cmf.keytab /etc/cloudera-scm-server/
sudo chown cloudera-scm:cloudera-scm /etc/cloudera-scm-server/cmf.keytab
sudo chmod 600 /etc/cloudera-scm-server/cmf.keytab


#vim /etc/cloudera-scm-server/cmf.principal
sudo echo "cloudera-scm@ap-southeast-1.compute.internal" > /etc/cloudera-scm-server/cmf.principal
sudo chown cloudera-scm:cloudera-scm /etc/cloudera-scm-server/cmf.principal
sudo chmod 600 /etc/cloudera-scm-server/cmf.principal

sudo service krb5kdc start
sudo service kadmin start

# Might need to make this to 766 
# sudo chmod 766 kadmind.log
# sudo chmod 766 krb5kdc.log

sudo echo "sudo service krb5kdc start" >> /home/centos/.bashrc
sudo echo "sudo service kadmin start" >> /home/centos/.bashrc

echo "GO TO CLOUDERA MANAGER"

# In Cloudera Manager:
# Administration -> Settings -> Security ->Kerberos Security Realm -> ap-southeast-1.compute.internal
# Add this as the realm -> "ap-southeast-1.compute.internal"
# KDC Server Host -> "IP address or Full Hostname" eg.ip-172-31-28-114.ap-southeast-1.compute.internal
# KDC Admin Server Host -> "IP address or Full Hostname" eg.ip-172-31-28-114.ap-southeast-1.compute.internal
