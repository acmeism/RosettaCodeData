#!/bin/bash
isnum() {
  printf "%f" $1 >/dev/null 2>&1
}


check() {
  if isnum $1
  then
     echo "$1 is numeric"
  else
     echo "$1 is NOT numeric"
  fi
}

check 2
check -3
check +45.44
check -33.332
check 33.aa
check 3.3.3
