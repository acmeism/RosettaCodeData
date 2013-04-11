#!/bin/sh

if [ -z $1 ]; then exit 1; fi

# weed out multiple erros due to bad year
ncal 1 $1 > /dev/null && \
for m in 01 02 03 04 05 06 07 08 09 10 11 12; do
	echo $1-$m-`ncal $m $1 | grep Fr | sed 's/.* \([0-9]\)/\1/'`
done
