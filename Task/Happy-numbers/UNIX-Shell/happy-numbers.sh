#!/bin/bash
function sum_of_square_digits
{
  local -i n="$1" sum=0
  while (( n )); do
    local -i d=n%10
    let sum+=d*d
    let n=n/10
  done
  echo "$sum"
}

function is_happy?
{
   local -i n="$1"
   local seen=()
   while (( n != 1 )); do
     if [ -n "${seen[$n]}" ]; then
        return 1
     fi
     seen[n]=1
     let n="$(sum_of_square_digits "$n")"
   done
   return 0
}

function first_n_happy
{
  local -i count="$1"
  local -i n
  for (( n=0; count; n+=1 )); do
  if is_happy? "$n"; then
    echo "$n"
    let count-=1
  fi
  done
  return 0
}

first_n_happy 8
