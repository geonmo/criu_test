#!/bin/bash
PIDN=$(ps -C test_sleep.sh|awk '{print $1}'| egrep -v "PID")
criu dump -t $PIDN --shell-job
