#!/bin/bash

for x in {1..3};
do
	scp -o StrictHostKeyChecking=no $HOME/.ssh/id_rsa node$x:~/.ssh
	ssh node$x chmod 400 ~/.ssh/id_rsa
done
