#!/bin/sh

if [ -t 1 ]
then
   echo "Output is a terminal"
else
   echo "Output is NOT a terminal" >/dev/tty
fi
