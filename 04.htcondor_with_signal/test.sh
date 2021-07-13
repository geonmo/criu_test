#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)
	criu dump -v5 -j -t ${TPID} --evasive-devices #--leave-running 
    tar -czvf dump.tar.gz *.img stats* sleep*.log
    scp dump.tar.gz geonmo@node0:~/dump.tar.gz
	ls /proc/${TPID}/fd/*
	cat /proc/${TPID}/fdinfo/0
    exit 85
}

ls /proc/$$/fd/*
cat /proc/$$/fdinfo/0


if [ -s dump.tar.gz ]; then
    tar -zxvf dump.tar.gz
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

