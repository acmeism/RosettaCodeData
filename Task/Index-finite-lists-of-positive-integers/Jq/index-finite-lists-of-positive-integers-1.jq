include "fibonacci" {search: "./"}; # see https://rosettacode.org/wiki/Category:Jq/fibonacci.jq

# Input: an array of integers
# Output: an integer-valued binary string, being the reverse of the concatenated Fibonacci-encoded values
def rank:
  map(fibencode | map(tostring) | join(""))
  | "1" + join("");

# Input a bitstring or 0-1 integer interpreted as a bitstring
# Output: an array of integers
def unrank:
  tostring
  | .[1:]
  | split("11")
  | .[:-1]
  | map(. + "11" | fibdecode) ;

# Output: a PRN in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs) | tostring] | join("") | sub("^0+";"") | tonumber
  | if . < $n then . else $n | prn end
  end;

### The task
# Encode and decode a random number of distinct positive numbers chosen at random.
# Produce a JSON object showing the set of numbers, their encoding, and
# the result of comparing the original set with the reconstructed set.
def task:
  (11 | prn) + 1
  | . as $numbers
  | [range(0;$numbers) | 100000 | prn + 1]
  | . as $numbers
  | rank
  | . as $encoded
  # now decode:
  | unrank
  | {$numbers, encoded: ($encoded|tonumber), check: ($numbers == .)}
;

task
