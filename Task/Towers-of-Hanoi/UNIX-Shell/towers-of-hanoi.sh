#!/bin/bash

move()
{
  local n="$1"
  local from="$2"
  local to="$3"
  local via="$4"

  if [[ "$n" == "1" ]]
  then
    echo "Move disk from pole $from to pole $to"
  else
    move $(($n - 1)) $from $via $to
    move 1 $from $to $via
    move $(($n - 1)) $via $to $from
  fi
}

move $1 $2 $3 $4
