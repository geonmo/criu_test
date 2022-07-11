#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)

	#criu dump -v5 -j -t ${TPID} -o dump.log --evasive-devices #--leave-running
	#echo "$(pwd)" > workdir 
        #if [ ! -s tpid ]; then	
	#	echo ${TPID} > tpid
	#fi
    	#tar -czvf dump.tar.gz *.img stats* sleep*.log workdir tpid

	## Debuging
	#sudo chown geonmo.geonmo dump.log
	#cp dump.log /mnt/share/geonmo

	#cp -f dump.tar.gz /mnt/share/geonmo/
	#sudo rm -rf ${WORKDIR}
	echo "Checkpoint!!"
	exit 85
}
	whoami
	pwd
	echo "Process PID is $$"

	./test_selfcheckpoint_sleep.sh & #>sleep_output.log 2> sleep_error.log < /dev/null &
	TPID=$!
	wait ${TPID}
	echo "sleep program is finished!"
	exit 0
