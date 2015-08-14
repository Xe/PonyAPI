#!/bin/bash

set -e

for client in *
do
	if [ -d "$client" ]
	then
		time (cd "$client" && ./test.sh)
	fi
done
