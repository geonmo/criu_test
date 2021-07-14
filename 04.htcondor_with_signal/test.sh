#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)

	criu dump -v5 -j -t ${TPID} -o dump.log --evasive-devices #--leave-running 
	echo "$(pwd)" >> workdir 
	echo ${TPID} >> tpid
    	tar -czvf dump.tar.gz *.img stats* sleep*.log workdir tpid
	## Debuging
	sudo chown geonmo.geonmo dump.log
	cp dump.log /mnt/share/geonmo

	cp -f dump.tar.gz /mnt/share/geonmo/
	rm -rf ${WORKDIR}
	exit 85
}


if [ -s dump.tar.gz ]; then
        tar -zxvf dump.tar.gz
	WORKDIR=$(cat workdir)
	rm -rf {WORKDIR}
	#sudo cp -al $(pwd) ${WORKDIR} 
	sudo cp -al $(pwd) ${WORKDIR} 
	#cd ${WORKDIR}
         	
	
	setsid -f criu restore -j
	sleep 2
	#criu restore -j &
	#TPID=i$!
	TPID=$(cat tpid)
	while true
	do
		echo "Monitoring ${TPID} procces"
		kill -s 0 ${TPID} 
		if [ $? -ne 0 ]
        	then
		   exit 0   
		fi
		sleep 1
	done
else
	#setsid -f ./test_sleep.sh > sleep_output.log 2> sleep_error.log < /dev/null 
	./test_sleep.sh > sleep_output.log 2> sleep_error.log < /dev/null &
        #wait $!	
	TPID=$!
	wait ${TPID}

	#while true
	#do
	#    echo "Monitoring ${TPID} procces"
	#    if ! pgrep -x test_sleep.sh
        #then
        #   exit 0   
	#fi
	#   sleep 1
	#done
fi

