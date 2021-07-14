#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)
	echo "dumping ${TPID} process"
	criu dump -v5 -j -t ${TPID} #--evasive-devices #--leave-running 
   	exit 85
}


if [ -s stats-dump ]; then
	criu restore -j -d
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
	setsid -f ./test_sleep.sh #> sleep_output.log 2> sleep_error.log & 
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






