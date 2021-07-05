#!/bin/bash
PIDN=$(pgrep test_sleep.sh)
criu dump -t $PIDN --shell-job
