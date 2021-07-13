#!/bin/bash

trap ReceiveCheckPointSignal SIGUSR2

function ReceiveCheckPointSignal() {
	TPID=$(pgrep test_sleep.sh)
	criu dump -t ${TPID} -v5 -j #--evasive-devices --leave-running 
}



./test_sleep.sh > output.log 2> error.log &
wait





