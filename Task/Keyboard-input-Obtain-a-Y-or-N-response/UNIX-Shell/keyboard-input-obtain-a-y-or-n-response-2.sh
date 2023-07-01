#!/bin/bash

yorn() {
  echo -n "${1:-Press Y or N to continue: }"

  shopt -s nocasematch

  until [[ "$ans" == [yn] ]]
  do
    read -s -n1 ans
  done

  echo "$ans"

  shopt -u nocasematch
}

yorn
