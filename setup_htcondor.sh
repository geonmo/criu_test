#!/bin/bash

NODE=${HOSTNAME::5}
#if $HOSTNAME
echo $NODE

if [ $NODE == "node0" ];
then
	echo "node0"
	ROLE="submit"
elif [ $NODE == "node1" ];
then
	echo "node1"
	ROLE="central-manager"
else
	echo "another"
	ROLE="execute"
fi


echo "Role is $ROLE"
curl -fsSL https://get.htcondor.org | sudo /bin/bash -s -- --no-dry-run --password "gsdc_password" --$ROLE node1.intranet.local
