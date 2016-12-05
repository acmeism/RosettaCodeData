#!/bin/sh
error() {
  echo >&2 "$0: $*"
  exit 1
}

[ $# -ne 3 ] && error "Incorrect number of parameters"

file=$1
start=$2
count=$3
end=`expr $start + $count - 1`

[ -f "$file" ] || error "$file does not exist"

sed "$start,${end}d" "$file" >/tmp/$$ && mv /tmp/$$ "$file"
