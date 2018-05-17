#!/usr/bin/bash

sudo yum -y install krb5-workstation krb5-libs krb5-auth-dialog

sudo sed -i "17i udp_preference_limit = 1" /etc/krb5.conf \
&& sudo sed -i "18i default_tgs_enctypes = arcfour-hmac" /etc/krb5.conf \
&& sudo sed -i "19i default_tkt_enctypes = arcfour-hmac" /etc/krb5.conf

sudo sed -i "s/^# \.example\.com = EXAMPLE\.COM/\.example\.com = ap-southeast-1\.compute\.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^# example\.com = EXAMPLE\.COM/\example\.com = ap-southeast-1\.compute\.internal/" /etc/krb5.conf

sudo sed -i "s/^# EXAMPLE\.COM/ap-southeast-1\.compute\.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^#  kdc = kerberos\.example\.com/kdc = ip-172-31-28-114\.ap-southeast-1\.compute\.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^#  admin_server = kerberos\.example\.com/admin_server = ip-172-31-28-114\.ap-southeast-1\.compute.internal/" /etc/krb5.conf \
&& sudo sed -i "s/^# }/}/" /etc/krb5.conf
