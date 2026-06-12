# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  (. - (. % $j)) / $j ;

def iroot(a; b):
  if b < 2 then b
  else (a-1) as $a1
  | {c: 1,
     d: (($a1 + (b | idivide(1))) | idivide(a)) }
  | .d as $d
  | .e = ($a1 * $d + (b |idivide($d | power($a1))) | idivide(a))
  | until( .d == .c or .c == .e;
       .c = .d
       | .d = .e
       | .e as $e
       | .e = ($a1 * .e + (b | idivide(($e | power($a1)))) | idivide(a)) )
  | [.d, .e] | min
  end ;

# The task:
"First 2,001 digits of the square root of two:",
iroot(2; 2 * (100 | power(2000)))
