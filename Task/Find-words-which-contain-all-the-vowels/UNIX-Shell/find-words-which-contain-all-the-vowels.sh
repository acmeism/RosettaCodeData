#!/bin/bash

dictionary_file="$1"  # $1 is the first argument when invoked on CLI
[[ -e "$dictionary_file" ]] || echo "invalid dictionary file"

while IFS= read -r line; do
  [[ ${#line} -le 10 ]] && continue  # skip to the next word
  a=0; e=0; i=0; o=0; u=0;
  for (( i=0; i<${#line}; i++ )); do
    char="${line:$i:1}"
    case "$char" in
      a|A) ((a++));;
      e|E) ((e++));;
      i|I) ((i++));;
      o|O) ((o++));;
      u|U) ((u++));;
    esac
  done
  [[ a -eq 1 && e -eq 1 && i -eq 1 && o -eq 1 && u -eq 1 ]] && echo "$line"
done < "${dictionary_file}"
