# A stream of factorials
# [N|factorials][n] is n!
def factorials:
   select(. > 0)
   | 1,
     foreach range(1; .) as $n(1; . * $n);

# The base-$b factorions less than or equal to $max
def factorions($b; $max):
  ($max // 1500000) as $max
  | [$b|factorials] as $fact
  | range(1; $max) as $i
  | {sum: 0, j: $i}
  | until( .j == 0 or .sum > $i;
       ( .j % $b) as $d
       | .sum += $fact[$d]
       | .j = ((.j/$b)|floor) )
  | select(.sum == $i)
  | $i ;

# input: base
# output: an upper bound for the factorions in that base
def sufficient:
  . as $base
  | [12|factorials] as $fact
  | $fact[$base-1] as $f
  | { digits: 1, value: $base}
  | until ( (.value > ($f * .digits) );
     .digits += 1
     | .value *= $base )  ;

# Show the factorions for all based from 2 through 12:
(range(2;10)
 | . as $base
 | sufficient.value as $max
 | {$base, factorions: ([factorions($base; $max)] | join(" "))}),
  {base: 10, factorions: ([factorions(10; 1500000)] | join(" "))},  # limit per the task description
  {base: 11, factorions: ([factorions(11; 50000)] | join(" "))},    # a limit known to be sufficient per (*)
  {base: 12, factorions: ([factorions(12; 50000)] | join(" "))}     # a limit known to be sufficient per (*)
