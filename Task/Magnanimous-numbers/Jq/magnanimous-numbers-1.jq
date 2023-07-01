# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def divrem($x; $y):
  [$x/$y|floor, $x % $y];
