#!/bin/bash
count=0
ls -l $PWD
while :; 
do
	echo $count  | tee -a running.txt
	count=$((count+1))
	sleep 2
	if [ $count -ge 50 ];then
		exit 0
	fi
done

