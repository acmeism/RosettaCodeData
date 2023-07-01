# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Input: a non-negative integer determining when to stop
def count_in_factors:
  "1: 1",
  (range(2;.) | "\(.): \([factors] | join("x"))");

def count_in_factors($m;$n):
  if  . == 1 then  "1: 1" else empty end,
  (range($m;$n) | "\(.): \([factors] | join("x"))");
