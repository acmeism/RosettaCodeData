#!/bin/sh

pathlist='/home/user1/tmp/coverage/test
/home/user1/tmp/covert/operator
/home/user1/tmp/coven/members'

i=2

while [ $i -lt 100 ]
do
  path=`echo "$pathlist" | cut -f1-$i -d/ | uniq -d`
  if [ -z "$path" ]
  then
     echo $prev_path
     break
  else
     prev_path=$path
  fi
  i=`expr $i + 1`
done
