## Generic functions
def assertEq($a; $b):
  if $a == $b then .
  else . as $in
  | "assertion violation: \($a) != \($b)" | debug
  | $in
  end;

# Emit a stream of characters
def chars: explode[] | [.] | implode;

# Input: a string of "0"s and "1"s
def flip:
  {"1": "0", "0": "1"} as $flip
  | reduce chars as $c (""; . + $flip[$c]);

def fibWord($n):
  { sn1: "0", sn: "01" }
  | reduce range (2; 1+$n) as $i (.; {sn: (.sn+.sn1), sn1: .sn})
  | .sn;

### Sturmian words

def SturmianWordRat($m; $n):
  if $m > $n
  then SturmianWordRat($n; $m) | flip
  else {sturmian: "", k: 1}
  | until (.k * $m % $n == 0;
      ( (.k * $m / $n)|floor) as $curr
      | (((.k - 1) * $m / $n)|floor) as $prev
      | .sturmian += (if $prev == $curr then "0" else "10" end)
      | .k += 1 )
  | .sturmian
  end;

def SturmianWordQuad($a; $b; $m; $n; $k):
  def fraction: . - trunc;
    { p: [0, 1],
      q: [1, 0],
     rem: ((($a|sqrt) * $b + $m) / $n)
    }
    | reduce range(1; 1+$k) as $i (.;
          (.rem|trunc) as $whole
          | (.rem|fraction) as $frac
          | ($whole * .p[-1] + .p[-2]) as $pn
          | ($whole * .q[-1] + .q[-2]) as $qn
          | .p += [$pn]
          | .q += [$qn]
          | .rem = (1 / $frac) )
    | SturmianWordRat(.p[-1]; .q[-1]) ;

### The tasks

def tasks:
  fibWord(10) as $fib
  | SturmianWordRat(13; 21) as $sturmian
  | SturmianWordQuad(5; 1; -1; 2; 8) as $sturmian2

  | assertEq($fib[0:$sturmian|length]; $sturmian)
  | assertEq($sturmian; $sturmian2)

  | "\($sturmian) from rational number 13/21",
    "\($sturmian2) from quadratic number (√5 - 1)/2 (k = 8)";

tasks
