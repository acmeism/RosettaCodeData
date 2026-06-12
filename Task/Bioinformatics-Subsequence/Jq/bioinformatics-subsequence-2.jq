#!/bin/bash

jot -r 200 0 3 | jq -nr --slurpfile four <(jot -r 4 0 3) '

 # input: an array of integers
 def toDNA:
   def base: . as $in | "ACGT" | .[$in : $in+1];
   map(base) | join("");

 ([inputs] | toDNA) as $strand
 | ($four  | toDNA) as $four
 | "Strand of length \($strand|length):",
   $strand,
   "Zero-based indices of \($four):",
   ($strand | indices($four) | join(" "))
'
