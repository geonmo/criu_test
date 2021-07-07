#!/bin/bash

setsid ./test_sleep.sh &

sleep 15

mkdir -p $HOME/dump/01
cd $HOME/dump/01



TPID=$(pgrep test_sleep.sh)
lsof -p ${TPID}

echo "test.sh's FD"
ls -l /proc/$$/fd
cat /proc/$$/fdinfo/1


echo "test_sleep.sh's FD"
ls -l /proc/${TPID}/fd
cat /proc/${TPID}/fdinfo/1


echo "$_CONDOR_SCRATCH_DIR"
echo "$$"

STDOUT_INODE=$(ls -il $_CONDOR_SCRATCH_DIR/_condor_stdout| cut -d' ' -f1)

echo "_stdout's inode ; ${STDOUT_INODE}"
#criu dump -t $(pgrep test_sleep.sh) -j --link-remap -o $HOME/dump/01/output.log
criu dump -t ${TPID} -j --external pipe[${STDOUT_INODE}] -o $HOME/dump/01/output.log


#sleep 5


#env

#cat /etc/*-release

#cat /proc/$$/mountinfo
