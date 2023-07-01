#!/bin/bash
# seq is the array genereated by hailstone
# index is used for seq
declare -a seq
declare -i index

# Create a routine to generate the hailstone sequence for a number
hailstone () {
  unset seq index
  seq[$((index++))]=$((n=$1))
  while [ $n -ne 1 ]; do
    [ $((n % 2)) -eq 1 ] && ((n=n*3+1)) || ((n=n/2))
    seq[$((index++))]=$n
  done
}

# Use the routine to show that the hailstone sequence for the number 27
# has 112 elements starting with 27, 82, 41, 124 and ending with 8, 4, 2, 1
i=27
hailstone $i
echo "$i: ${#seq[@]}"
echo "${seq[@]:0:4} ... ${seq[@]:(-4):4}"

# Show the number less than 100,000 which has the longest hailstone
# sequence together with that sequences length.
# (But don't show the actual sequence)!
max=0
maxlen=0
for ((i=1;i<100000;i++)); do
  hailstone $i
  if [ $((len=${#seq[@]})) -gt $maxlen ]; then
    max=$i
    maxlen=$len
  fi
done

echo "${max} has a hailstone sequence length of ${maxlen}"
