#!/bin/sh
cat $1 | awk '{printf ($NF~"BCE")?"-":"";printf $(NF-1)" "; print $0}' | sort -nk 1 | sed 's/^[^ ]* //g'
