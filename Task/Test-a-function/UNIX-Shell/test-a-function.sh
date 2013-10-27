#!/bin/bash

is_palindrome() {
  local s1=$1
  local s2=$(echo $1 | tr -d "[ ,!:;.'\"]" | tr '[A-Z]' '[a-z]')

  if [[ $s2 = $(echo $s2 | rev) ]]
  then
     echo "[$s1] is a palindrome"
  else
     echo "[$s1] is NOT a palindrome"
  fi
}
