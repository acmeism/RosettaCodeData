#!/bin/bash

roman-to-decimal() {
  local rnum="$1"
  local -i n prev
  local -riA R=(
    [M]=1000 [D]=500 [C]=100
    [L]=50 [X]=10 [V]=5 [I]=1
  )

  for ((i=${#rnum}-1;i>=0;i--))
  do ((
    a=R[${rnum:i:1}],
    n += a < prev ? -a : +a,
    prev=a
  ))
  done

  echo "$rnum = $n"
}

roman-to-decimal MCMXC
roman-to-decimal MMVIII
roman-to-decimal MDCLXVI
