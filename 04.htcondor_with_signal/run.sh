#!/bin/bash

if [ ! -s /mnt/share/geonmo/dump.tar.gz ]; then
	touch /mnt/share/geonmo/dump.tar.gz
fi
condor_submit submit.jdl

