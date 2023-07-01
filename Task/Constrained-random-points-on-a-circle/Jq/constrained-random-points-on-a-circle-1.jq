#!/bin/bash

< /dev/random tr -cd '0-9' | fold -w 1 | jq -Mcnr '

# Output: a PRN in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def ss: map(.*.) | add;

# Input: [x,y]
# Emit . iff ss lies within the given bounds
def annulus($min; $max) : ss as $sum | select($min <= $sum and $sum <= $max);

limit(100;
      repeat([((30 | prn) - 15), ((30 | prn) - 15)]
             | select( annulus(100; 225)) ))
| "\(.[0]) \(.[1])"
' > rc-annulus.dat
