#!/bin/sh
error() {
  echo "$*"
  exit 1
}

[ $# -ne 3 ] && error "Incorrect number of parameters"

file=$1
start=$2
end=$3

[ -f $file ] || error "$file does not exist"

sed $start,${end}d $file >/tmp/$$ && mv /tmp/$$ $file
