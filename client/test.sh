#!/bin/bash

set -e

for client in *
do
	if [ -d "$client" ]
	then
		(cd "$client" && ./test.sh)
	fi
done
