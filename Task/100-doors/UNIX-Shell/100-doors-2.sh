#!/bin/bash

for i in {1..100}; do
  door[$i*$i]=1
  [ -z ${door[$i]} ] && echo "$i closed" || echo "$i open"
done
