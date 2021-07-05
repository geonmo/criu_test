#!/bin/bash

for x in {1..3};
do
	scp $HOME/.ssh/id_rsa node$x:~/.ssh
	ssh node$x chmod 400 ~/.ssh/id_rsa
done
