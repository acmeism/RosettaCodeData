#!/bin/bash

# Basic principle:
#
#
#  x ->  dxd       d -> dd      s -> s
#        xsx            dd           s
#
# In the end all 'd' and 's' are removed.
# 0x7F800000
function rec(){
  if [ $1 == 0 ]
  then
    echo "x"
  else
    rec $[ $1 - 1 ] | while read line ; do
      echo "$line" | sed "s/d/dd/g" | sed "s/x/dxd/g"
      echo "$line" | sed "s/d/dd/g" | sed "s/x/xsx/g"
    done
  fi
}

rec $1 | tr 'dsx' '  *'
