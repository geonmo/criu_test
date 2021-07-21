#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	#TPID=$(pgrep test_root.py)

	echo "Call signal SIGUSR2"

	criu dump -v5 -j -t ${TPID} -o /tmp/dump.log --evasive-devices #--leave-running
	echo "$(pwd)" > workdir 
        if [ ! -s tpid ]; then	
		echo ${TPID} > tpid
	fi
    	tar -czvf dump.tar.gz *.img stats* root*.log workdir tpid h1.root

	echo "Before debugging"
	## Debuging
	sudo chown geonmo.geonmo /tmp/dump.log
	cp dump.log /mnt/share/geonmo
	echo "After debugging"

	cp -f dump.tar.gz /mnt/share/geonmo/
	sudo rm -rf ${WORKDIR}
	exit 85
}

source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=cc8_amd64_gcc9
cd /cvmfs/cms.cern.ch/cc8_amd64_gcc9/cms/cmssw/CMSSW_11_3_2/src
eval `scramv1 runtime -sh`

cd - 

if [ -s dump.tar.gz ]; then
        tar -zxvf dump.tar.gz
	WORKDIR=$(cat workdir)
	TPID=$(cat tpid)
	sudo ln -Tfs $(pwd) ${WORKDIR}
         	
	criu restore -d -j --inherit-fd "fd[7]:${WORKDIR:1}/root_output.log" --inherit-fd "fd[8]:${WORKDIR:1}/root_error.log" --inherit-fd "fd[9]:${WORKDIR:1}/test_root.py" --inherit-fd "fd[10]:${WORKDIR:1}/h1.root" 7>> root_output.log 8>>root_error.log 9> test_root.py 10>>h1.root
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
	sudo rm ${WORKDIR}
else
	./test_root.py > root_output.log 2> root_error.log < /dev/null &
	TPID=$!
	wait ${TPID}
fi

