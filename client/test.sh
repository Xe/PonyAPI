#!/bin/bash

set -e
set -x

for client in *
do
	if [ -d $client ]
	then
		(cd $client && ./test.sh)
	fi
done
