#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)
	mkdir dump-${TPID}
	criu dump -v5 -t ${TPID} -D dump-${TPID} -o criu.log # -j #--evasive-devices #--leave-running
	echo "$(pwd)" > workdir 
    	tar -czvf checkpoint.tar.gz dump-${TPID}
        if [ ! -e finish.txt ]; then
		touch finish.txt
	fi
	echo "Checkpoint!!" >> state_running.txt
	exit 85
}


if [ -s checkpoint.tar.gz ]; then
        tar -zxvf checkpoint.tar.gz
	DUMP_DIR=$(echo dump-*)
	TPID=${DUMP_DIR:5}
	echo ${DUMP_DIR}
	echo ${TPID}
	criu restore -d -D $DUMP_DIR
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
	setsid ./test_sleep.sh </dev/null &> /dev/null & 
	TPID=$!
	wait ${TPID}
fi

