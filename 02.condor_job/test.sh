#!/bin/bash

./test_sleep.sh > output.log 2> error.log &
#./test_sleep.sh & 

sleep 4

#mkdir -p $HOME/dump/01
#cd $HOME/dump/01



TPID=$(pgrep test_sleep.sh)
lsof -p ${TPID}

echo "test.sh's FD"
ls -l /proc/$$/fd
cat /proc/$$/fdinfo/1


echo "test_sleep.sh's FD"
ls -l /proc/${TPID}/fd
cat /proc/${TPID}/fdinfo/1



criu dump -t ${TPID} -v5 -j --evasive-devices --leave-running 
