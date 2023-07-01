#!/bin/sh
num=0
while test 0 -le $num; do
  printf '%o\n' $num
  num=`expr $num + 1`
done
