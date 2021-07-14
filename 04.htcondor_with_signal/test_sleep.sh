#!/bin/bash
count=0
while :; 
do
	echo $count
	count=$((count+1))
	sleep 2
	if [ $count -ge 50 ];then
		exit 0
	fi
done

