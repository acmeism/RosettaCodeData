#! /bin/bash

function BSD() {
  SEED=$(((1103515245 * $SEED + 12345) % 2**31))
  echo "  $SEED"
}

function MS() {
  SEED=$(((214013 * $SEED + 2531011) % 2**31))
  echo "  $(($SEED / 2**16))"
}

function output() {
  SEED=0
  echo "$1"

  for i in {1..10}; do
    eval "$1"
  done

  echo ""
}

output BSD
output MS
