#!/bin/bash

_user=`whoami`
if [ "X$_user" != "Xroot" ] ; then
	echo "exec by root only because debian do not install sudo in default"
	exit 1
fi

if [ ! -f /root/.ssh/authrozed_keys ] ; then
	"root authorized_kyes is not existed"
	exit 1
fi

if [ $# -ne 1 ] ;
	echo "Usage: $0 username"
	exit 1
fi

USER=$1
UID=$1
PASS=$2

# sudo
apt-get -y install sudo

# create management user 
useradd -m -u $UID -G sudo $USER
cp /root/.ssh/authrozed_keys /home/${USER}/.ssh
chown -R ${USER}:${USER} /home/${USER}/.ssh 

# date and time
timedatectl set-timezone Asia/Tokyo

# reconf sshd
sed -ie "s/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/"
sed -ie "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/"
systemctl restart sshd.service

# vim
apt-get install -y vim
update-alternatives --set editor /usr/bin/vim.basic

# ntp
apt-get install -y chrony
sed -i -e "s/2.debian.pool.ntp.org/ntp.kawawa.dev/"
systemctl restart chrony.service

# ipv4 fowarding
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward = 1" | tee /etc/sysctl.d/90-custom.conf
