#!/bin/ksh

typeset -A INDEX

function index {
  typeset num=0
  for file in "$@"; do
    tr -s '[:punct:]' ' ' < "$file" | while read line; do
      for token in $line; do
        INDEX[$token][$num]=$file
      done
    done
  ((++num))
  done
}

function search {
  for token in "$@"; do
    for file in "${INDEX[$token][@]}"; do
      echo "$file"
    done
  done | sort | uniq -c | while read count file; do
    (( count == $# )) && echo $file
  done
}
