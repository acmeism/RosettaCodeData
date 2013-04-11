#!/bin/bash

a=0
b=1
max=$1

for (( n=1; "$n" <= "$max"; $((n++)) ))
do
  a=$(($a + $b))
  echo "F($n): $a"
  b=$(($a - $b))
done
