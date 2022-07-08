#!/bin/bash
count=0
ls -l $PWD
if [ -e outlog.txt ]; then
    echo "Found outlog.txt"
    count=$(tail -n1 outlog.txt)
    echo "begin: $count"
fi
while :; 
do
	echo $count | tee -a outlog.txt
	count=$((count+1))
	sleep 2
	if [ $count -ge 50 ];then
		echo "Job is finished" > finish.txt
		exit 0
	fi
done

