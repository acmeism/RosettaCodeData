# idivide/1 is written to take advantage of gojq's support for
# unbounded-precision integer arithmetic;
# the last last line (invoking `round`) is for the sake of jaq.
def idivide($j):
  (. % $j) as $mod
  | (. - $mod) / $j
  | round  # solely for jaq
  ;

def leftshift($n):
  reduce range(0;$n) as $i (.; . * 2);

def divmod($j):
  (. % $j) as $mod
  | [((. - $mod) | idivide($j)), $mod] ;

# Emit a stream of the digits in the given non-negative integer
def digits: explode[] | . - 48;

# Bit arrays and polynomials

# Convert the input integer to a stream of 0s and 1s, least significant bit first
def bitwise:
  recurse( if . >= 2 then idivide(2) else empty end) | . % 2;

# Evaluate the input polynomial at $x
def eval($x):
  . as $p
  | reduce range(0; length) as $i ({power: 1, ans: 0};
      .ans += $p[$i] * .power
      | .power *= $x )
  | .ans;


### Rice Encoding

#  Input should be a non-negative integer
def encode($k):
  (1 | leftshift($k)) as $m
  | divmod($m) as [$q, $r]
  | ([range(0;$q) | 1] + [0])
  | ([ $r | bitwise ] | reverse) as $digits
  | ($digits|length) as $dc
  | if $dc < $k then . +  [range(0; $k - $dc) | 0] end
  | . + $digits ;

def encodeEx($k):
  if . < 0 then -2 * . - 1 else  2 * . end
  | encode($k);

def decode($k):
  (1 | leftshift($k)) as $m
  | (index(0) | if . == -1 then 0 else . end) as $q
  | ( .[$q:] | reverse| eval(2)) as $r
  | $q * $m + $r;

def decodeEx($k):
  decode($k) as $i
  | if $i % 2 == 1 then - ($i+1 | idivide(2)) else ($i | idivide(2)) end;

"Basic Rice coding (k = 2):",
(range(0;11)
 | encode(2) as $res
 | "\(.) -> \($res|join("")) => \($res|decode(2))" ),

"\nExtended Rice coding (k == 2):",
(range (-10; 11)
 | encodeEx(2) as $res
 | "\(.) -> \($res|join("")) => \($res|decodeEx(2))" ),

"\nBasic Rice coding (k == 4):",
( range (0; 18)
  | encode(4) as $res
  | "\(.) -> \($res|join("")) => \($res|decode(4))" )
