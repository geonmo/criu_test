#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)

	#ls /proc/${TPID}/fd/*
	#cat /proc/${TPID}/fdinfo/0

	criu dump -v5 -j -t ${TPID} -o /mnt/share/geonmo/dump.log --evasive-devices #--leave-running 
	echo "$(pwd)" >> workdir 
    	tar -czvf dump.tar.gz *.img stats* sleep*.log workdir
	cp -f dump.tar.gz /mnt/share/geonmo/
	rm -rf ${WORKDIR}
	exit 85
}


if [ -s /mnt/share/geonmo/dump.tar.gz ]; then
	#cp test_sleep.sh /mnt/share/geonmo
	#cd /mnt/share/geonmo
        tar -zxvf dump.tar.gz
	WORKDIR=$(cat workdir)
	rm -rf {WORKDIR}
	sudo cp -al $(pwd) ${WORKDIR} 
	#sudo mkdir ${WORKDIR}
	#sudo chown geonmo.geonmo ${WORKDIR}
        #sudo cp -rf * ${WORKDIR}
	cd ${WORKDIR}
         	
	
	setsid -f criu restore -j
	TPID=$(pgrep test_sleep.sh)
	while true
	do
		echo "Monitoring ${TPID} procces"
		if ! pgrep -x test_sleep.sh 
        then
		   exit 0   
		fi
		sleep 1
	done
else
	setsid -f ./test_sleep.sh > sleep_output.log 2> sleep_error.log < /dev/null 
	TPID=$(pgrep test_sleep.sh)
	while true
	do
	    echo "Monitoring ${TPID} procces"
		if ! pgrep -x test_sleep.sh
        then
           exit 0   
		fi
		sleep 1
	done
fi

