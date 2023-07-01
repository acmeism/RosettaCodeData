def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;

def idiv2: (. - (. % 2)) / 2;

def bitwise:
  recurse( if . >= 2 then idiv2 else empty end) | . % 2;

def bitwise_and_nonzero($x; $y):
  [$x|bitwise] as $x
  | [$y|bitwise] as $y
  | ([$x, $y] | map(length) | min) as $min
  | any(range(0; $min) ; $x[.] == 1 and $y[.] == 1);
