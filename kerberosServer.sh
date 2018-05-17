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
&& sudo sed -i "s/^#  kdc = kerberos\.example\.com/kdc = ip-172-31-28-114\.ap-southeast-1\.compute\.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^#  admin_server = kerberos\.example\.com/  admin_server = ip-172-31-28-114\.ap-southeast-1\.compute.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^# }/ }/" /etc/krb5.conf

sudo sed -i "s/^# default_realm = EXAMPLE.COM/default_realm = ap-southeast-1\.compute\.internal/" /etc/krb5.conf

# Interactive
sudo /usr/sbin/kdb5_util create -s
#Interactive
sudo kadmin.local
# This is what i'm adding -> "addprinc cloudera-scm@ap-southeast-1.compute.internal" | password -> "cdh1234" | to exit -> "q"

sudo echo "*/admin@ap-southeast-1.compute.internal	*" > /var/kerberos/krb5kdc/kadm5.acl
sudo echo "cloudera-scm@ap-southeast-1.compute.internal admilc" >> /var/kerberos/krb5kdc/kadm5.acl
