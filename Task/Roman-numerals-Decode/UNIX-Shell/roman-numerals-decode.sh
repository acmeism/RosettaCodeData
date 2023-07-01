#!/bin/bash

roman_to_dec() {
  local rnum=$1
  local n=0
  local prev=0

  for ((i=${#rnum}-1;i>=0;i--))
  do
    case "${rnum:$i:1}" in
    M)  a=1000 ;;
    D)  a=500 ;;
    C)  a=100 ;;
    L)  a=50 ;;
    X)  a=10 ;;
    V)  a=5 ;;
    I)  a=1 ;;
    esac

    if [[ $a -lt $prev ]]
    then
       let n-=a
    else
       let n+=a
    fi

    prev=$a
  done

  echo "$rnum = $n"
}

roman_to_dec MCMXC
roman_to_dec MMVIII
roman_to_dec MDCLXVI
