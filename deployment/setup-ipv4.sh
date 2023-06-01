#!/bin/bash

# this script should run as root and has been tested with ubuntu 20.04

apt-get update && apt-get -y upgrade
apt-get install -y linux-headers-$(uname -r)
apt-get install -y build-essential make zlib1g-dev librrd-dev libpcap-dev autoconf automake libarchive-dev htop bmon vim wget pkg-config git python-dev python3-pip libtool iperf3
pip install --upgrade pip

############################
####     TCP TUNING     ####
############################

cat >> /etc/sysctl.conf <<EOL
# enable forwarding
# net.ipv4.ip_forward=1
# allow testing with buffers up to 128MB
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728 
# increase Linux autotuning TCP buffer limit to 128MB
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 87380 134217728
# recommended default congestion control is htcp  or bbr
net.ipv4.tcp_congestion_control=bbr
# recommended for hosts with jumbo frames enabled
net.ipv4.tcp_mtu_probing=1
# recommended to enable 'fair queueing'
# net.core.default_qdisc = fq
EOL

############################
####   Install BBRv2    ####
############################
wget https://workflow.isi.edu/Poseidon/fabric/kernel-+v2alpha+a23c4bb59e0c+FABRIC.tar.gz2
tar --no-same-owner -xzvf kernel-+v2alpha+a23c4bb59e0c+FABRIC.tar.gz2 -C /
cd /boot
for v in $(ls vmlinuz-* | sed s/vmlinuz-//g); do
    mkinitramfs -k -o initrd.img-${v} ${v}
done
update-grub

##### REBOOT IS REQUIRED BUT SHOULD HAPPEN FROM THE JUPYTER SIDE ######
