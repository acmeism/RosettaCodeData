#!/bin/bash
trap 'echo "Run for $((s/2)) seconds"; exit' 2
s=1

half_sec_sleep()
{
  local save_tty=$(stty -g)
  stty -icanon time 5 min 0
  read
  stty $save_tty
}


while true
do
  echo $s
  half_sec_sleep
  let s++
done
