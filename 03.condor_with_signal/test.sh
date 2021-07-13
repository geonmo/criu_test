#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)
	criu dump -v5 -j -t ${TPID} #--evasive-devices #--leave-running 
}


if [ -s stats-dump ]; then
	setsid -f criu restore -j
	#wait $(pgrep test_sleep.sh)
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
	#wait $(pgrep test_sleep.sh)
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






