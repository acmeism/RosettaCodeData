#!/bin/bash

set -eu

# make scratch directory
t="$(mktemp -d)"
cd "${t:?mktemp failed}"
trap 'rm -r -- "$t"' EXIT

# get character frequencies
declare -a freq=()
while read addr line; do
  for c in $line; do
    : $((freq[8#$c]++))
  done
done < <(od -b -v)

# convert freqs into a bucket queue
declare -i i=0
for c in ${!freq[@]}; do
  fn="${freq[c]}.$((i++))"
  echo "$c:${freq[c]}" >"$fn"
done

top2() { ls | sort -t. -k1,1n -k2,2n | sed 2q; }
set -- $(top2)
while [[ $# -gt 1 ]]; do
  declare -i l="${1%%.*}" r="${2%%.*}" # combine weights into
  fn="$((l + r)).$((i++))"             # ... new node weight
  mkdir "$fn"
  mv "$1" "$fn/0"
  mv "$2" "$fn/1"
  set -- $(top2)
done

echo -e "Symbol\tWeight\tHuffman Code"
cd "$fn"
find . -type f -exec grep . {} + |
  tr -d ./ |
  awk -F: '{printf "%c\t%d\t%s\n", $2, $3, $1}' |
  sort -k 2,2nr -k 3,3n
