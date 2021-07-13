#!/bin/bash

if [ ! -f dump.tar.gz ] ; then
    touch dump.tar.gz
fi

condor_submit submit.jdl

