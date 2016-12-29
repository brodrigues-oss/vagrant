#!/bin/bash
#
#   Author : brodrigues
#     Date : 2016-12-21
#  Purpose : This script is used to configure a VM to run with vagrant.
#
########################################################################

# function 

DATE=`date | tr -s '\n' ' '` 

# Create user 
useradd -c "Vagrant User" -G wheel --password=vagrant vagrant

if [ $? == 0 ]; then 
	echo "$DATE INFO User vagrant created successfully" 
else
	echo "$DATE ERROR User vagrant could not be created" 
fi	


# Install the wget package as we need it to download the vagrant key
echo "$DATE INFO installing wget.x86_64" 
yum -y install wget.x86_64 curl.x86_64 


# Enabling sudo-less access for vagrant user
echo "$DATE INFO enabling sudo-less access for vagrant user" 
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL"  >> /etc/sudoers.d/vagrant
echo "Defaults:vagrant !requiretty"                  >> /etc/sudoers.d/vagrant
echo "Defaults:%wheel env_keep += \"SSH_AUTH_SOCK\"" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

echo "$DATE INFO making ssh directory" 
/bin/mkdir -p /home/vagrant/.ssh

echo "$DATE INFO changing directory permissions on .ssh" 
/bin/chmod 700 /home/vagrant/.ssh

echo "$DATE INFO downloading *insecure* vagrant private key" 
/usr/bin/curl -L -o /home/vagrant/.ssh/id_rsa https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant

echo "$DATE INFO downloading vagrant public key" 
/usr/bin/curl -L -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub

echo "$DATE INFO changing ownership permissions on .ssh directory" 
/bin/chown -R vagrant:vagrant /home/vagrant/.ssh

echo "$DATE INFO changing file permissions on all files in .ssh dir" 
/bin/chmod 0400 /home/vagrant/.ssh/*

echo "$DATE INFO ALL DONE " 

