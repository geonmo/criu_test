#!/bin/bash

NODE=${HOSTNAME::5}

if [ ! -d "/mnt/share" ];
then
	sudo mkdir -p /mnt/share
	sudo chmod 777 /mnt/share
	sudo chmod +t /mnt/share
fi


if [ $NODE == "node0" ];
then
    	sudo dnf install -y nfs-utils
	echo "/mnt/share *(rw,no_subtree_check)" | sudo tee -a /etc/exports
	sudo firewall-cmd --add-service=nfs --permanent
	sudo firewall-cmd --reload
	sudo systemctl restart nfs-server
else
    	sudo dnf install -y nfs-utils
	echo "192.168.10.3:/mnt/share /mnt/share nfs defaults 0 0 " | sudo tee -a /etc/fstab
fi

