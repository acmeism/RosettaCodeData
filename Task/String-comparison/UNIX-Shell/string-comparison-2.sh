#!/bin/bash

isint() {
  printf "%d" $1 >/dev/null 2>&1
}

compare() {
  local a=$1
  local b=$2

  [[ $a = $b ]] && echo "'$a' and '$b' are lexically equal"
  [[ $a != $b ]] && echo "'$a' and '$b' are not lexically equal"

  [[ $a > $b ]] && echo "'$a' is lexically after '$b'"
  [[ $a < $b ]] && echo "'$a' is lexically before '$b'"

  shopt -s nocasematch # Turn on case insensitivity

  [[ $a = $b ]] && echo "'$a' and '$b' are equal with case insensitivity"

  shopt -u nocasematch # Turn off case insensitivity

  # If args are numeric, perform some numeric comparisions
  if isint $a && isint $b
  then
     [[ $a -eq $b ]] && echo "$a is numerically equal to $b"
     [[ $a -gt $b ]] && echo "$a is numerically greater than $b"
     [[ $a -lt $b ]] && echo "$a is numerically less than $b"
  fi

  echo
}


compare foo foo
compare foo bar
compare FOO foo
compare 24 123
compare 50 20
