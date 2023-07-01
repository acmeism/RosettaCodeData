#!/bin/sh
if [ "$1" -gt 0 ]; then
  "$0" "`expr $1 - 1`" "$2" "$4" "$3"
  echo "Move disk from pole $2 to pole $3"
  "$0" "`expr $1 - 1`" "$4" "$3" "$2"
fi
