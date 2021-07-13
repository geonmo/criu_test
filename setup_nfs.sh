#!/bin/bash

NODE=${HOSTNAME::5}

if [ ! -d "/mnt/share" ];
then
	sudo mkdir -p /mnt/share
fi

if [ -s "/etc/exports" ];
then
	echo "/mnt/share *(no_subtree_check)" | sudo tee -a /etc/exports
fi

if [ $NODE == "node0" ];
then
    sudo dnf install -y nfs-utils
	sudo firewall-cmd --add-service=nfs --permanent
	sudo firewall-cmd --reload
else
    sudo dnf install -y nfs-utils
	echo "192.168.10.3:/mnt/share /mnt/share nfs defaults 0 0 " | sudo tee -a /etc/fstab
fi

