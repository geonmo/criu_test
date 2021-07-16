#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)

	criu dump -v5 -j -t ${TPID} -o dump.log --evasive-devices #--leave-running
	echo "$(pwd)" > workdir 
        if [ ! -s tpid ]; then	
		echo ${TPID} > tpid
	fi
    	tar -czvf dump.tar.gz *.img stats* root*.log workdir tpid h1.root

	## Debuging
	sudo chown geonmo.geonmo dump.log
	cp dump.log /mnt/share/geonmo

	cp -f dump.tar.gz /mnt/share/geonmo/
	sudo rm -rf ${WORKDIR}
	exit 85
}


if [ -s dump.tar.gz ]; then
        tar -zxvf dump.tar.gz
	WORKDIR=$(cat workdir)
	sudo ln -Tfs $(pwd) ${WORKDIR}
         	
	criu restore -d -j --inherit-fd "fd[7]:${WORKDIR:1}/root_output.log" --inherit-fd "fd[8]:${WORKDIR:1}/root_error.log" --inherit-fd "fd[9]:${WORKDIR:1}/test_root.py" --inherit-fd "fd[10]:${WORKDIR:1}/h1.root" 7>> sleep_output.log 8>>sleep_error.log 9> test_sleep.sh 10>h1.root
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
	./test_root.py > root_output.log 2> root_error.log < /dev/null &
	TPID=$!
	wait ${TPID}
fi

