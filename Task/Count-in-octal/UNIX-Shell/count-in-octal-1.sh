#!/bin/sh
num=0
while true; do
  echo $num
  num=`echo "obase=8;ibase=8;$num+1"|bc`
done
