#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)
	mkdir dump-${TPID}
	criu dump -v5 -t ${TPID} -D dump-${TPID} -o criu.log # -j #--evasive-devices #--leave-running
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
else
	setsid ./test_sleep.sh </dev/null &> /dev/null & 
	TPID=$!
fi

while true
do
	echo "Monitoring ${TPID} procces"
	kill -s 0 ${TPID} 
	if [ $? -ne 0 ]
	then
	   exit 0   
	fi
	if [[ -e state_running.txt && $(tail -n1 state_running.txt) == "10" ]]; then
		kill -SIGUSR2 $$
	fi
	sleep 1
done
