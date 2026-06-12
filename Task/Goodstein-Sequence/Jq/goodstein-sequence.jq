# To take advantage of gojq's infintite-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be a pair of integers.
def divmod($j):
  . as $i
  | ($i % $j) as $mod
  | [($i - $mod) / $j, $mod] ;

# Given non-negative integer $n and base b$, return hereditary representation
# consisting of tuples (j, k) such that the sum of all (j * b^(evaluate(k; b)) == n.
def decompose($n; $b):
  if $n < $b then $n
  else { n: $n, decomp: [], e: 0 }
  | until (.n == 0;
      (.n | divmod($b)) as $t
      | .n = $t[0]
      | $t[1] as $r
      | if $r > 0 then .decomp += [[$r, decompose(.e; $b)]] end
      | .e += 1 )
  | .decomp
  end;

# Evaluate hereditary representation $d under base $b.
def evaluate($d; $b):
  if $d|type == "number" then $d
  else reduce $d[] as [$j, $k] (0;
        . + $j * ($b|power(evaluate($k; $b))) )
  end ;

# Return a vector of up to $limitlength values of the Goodstein sequence for $n.
def goodstein($n; $limitLength):
  { seq: [], b: 2, $n }
   | until (.n == false or (.seq|length) >= $limitLength ;
        .seq += [.n]
        | if .n == 0 then .n = false
          else decompose(.n; .b) as $d
          | .b += 1
          | .n = evaluate($d; .b) - 1
          end )
  | .seq;

# Get the $nth term of the Goodstein($n) sequence counting from 0
def a266201($n): goodstein($n; $n+1)[-1];

### The tasks
"Goodstein(n) sequence (first 10) for values of n in [0, 7]:",
(range (0;8) | "Goodstein of \(.): \(goodstein(.; 10))"),

"\nThe nth term of Goodstein(n) sequence counting from 0, for values of n in [0, 16]:",
( range (0;17) | "Term \(.) of Goodstein(\(.)): \(a266201(.))" )
