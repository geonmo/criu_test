#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)

	criu dump -v5 -j -t ${TPID} -o dump.log --evasive-devices #--leave-running
	echo "$(pwd)" > workdir 
        if [ ! -s tpid ]; then	
		echo ${TPID} > tpid
	fi
    	tar -czvf dump.tar.gz *.img stats* sleep*.log workdir tpid

	## Debuging
	sudo chown geonmo.geonmo dump.log

	cp -f dump.tar.gz /share/geonmo/
	#sudo rm -rf ${WORKDIR}
	exit 85
}


if [ -s dump.tar.gz ]; then
        tar -zxvf dump.tar.gz
	WORKDIR=$(cat workdir)
	sudo ln -Tfs $(pwd) ${WORKDIR}
         	
	criu restore -d -j --inherit-fd "fd[7]:${WORKDIR:1}/sleep_output.log" --inherit-fd "fd[8]:${WORKDIR:1}/sleep_error.log" --inherit-fd "fd[9]:${WORKDIR:1}/test_sleep.sh" 7>> sleep_output.log 8>>sleep_error.log 9> test_sleep.sh
	TPID=$(cat tpid)
else
	setsid ./test_sleep.sh </dev/null &> /dev/null &
	TPID=$!
fi
while true
do
        echo "Monitoring ${TPID} procces"
        kill -s 0 ${TPID}
        if [ $? -ne 0 ]; then
           exit 0
        fi
        if [[ -e state_running.txt && $(tail -n1 state_running.txt) == "10" ]]; then
                kill -SIGUSR2 $$
        fi
        sleep 1
done

