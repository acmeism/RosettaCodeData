# For gojq
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# input should be non-negative
def isqrt:
  . as $x
  | 1 | until(. > $x; . * 4) as $q
  | {$q, $x, r: 0}
  | until( .q <= 1;
           .q |= idivide(4)
           | .t = .x - .r - .q
           | .r |= idivide(2)
           | if .t >= 0
             then .x = .t
	     | .r += .q
             else . end).r ;

def power($n):
  . as $in
  | reduce range(0;$n) as $i (1; . * $in);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

## The task:

"The integer square roots of integers from 0 to 65 are:",
[range(0;66) | isqrt],
"",
"The integer square roots of odd powers of 7 from 7^1 up to 7^73 are:",
("power" + " "*16 + "7 ^ power" + " "*70 + "integer square root"),

(range( 1;74;2) as $i
  | (7 | power($i)) as $p
  | "\($i|lpad(2)) \($p|lpad(84)) \($p | isqrt | lpad(43))" )
