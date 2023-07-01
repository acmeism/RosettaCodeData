#!/bin/bash
trap 'echo "Run for $((s/2)) seconds"; exit' 2
s=1

while true
do
  echo $s
  sleep .5
  let s++
done
