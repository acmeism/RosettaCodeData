def mean: add/length;

def inner_product($y):
  . as $x
  | reduce range(0; length) as $i (0; . + ($x[$i] * $y[$i]));

# $x and $y should be arrays of the same length
# Emit { a, b, c, z}
# Attempt to avoid overflow
def polynomialRegression($x; $y):
  ($x | length) as $length
  | ($length * $length) as $l2
  | ($x  | map(./$length)) as $xs
  | ($xs | add) as $xm
  | ($y  | mean) as $ym
  | ($xs | map(. * .) | add * $length) as $x2m
  | ($x  | map( (./$length) * . * .) | add) as $x3m
  | ($xs | map(. * . | (.*.) ) | add * $l2 * $length) as $x4m
  | ($xs | inner_product($y)) as $xym
  | ($xs | map(. * .) | inner_product($y) * $length) as $x2ym

  | ($x2m - $xm * $xm) as $sxx
  | ($xym - $xm * $ym) as $sxy
  | ($x3m - $xm * $x2m) as $sxx2
  | ($x4m - $x2m * $x2m) as $sx2x2
  | ($x2ym - $x2m * $ym) as $sx2y
  | {z:  ([$x,$y] | transpose) }
  | .b = ($sxy * $sx2x2 - $sx2y * $sxx2) / ($sxx * $sx2x2 - $sxx2 * $sxx2)
  | .c = ($sx2y * $sxx - $sxy * $sxx2) / ($sxx * $sx2x2 - $sxx2 * $sxx2)
  | .a = $ym - .b * $xm - .c * $x2m ;

# Input: {a,b,c,z}
def report:
  def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;
  def abc($x):  .a + .b * $x + .c * $x * $x;
  def print($p): "\($p[0] | lpad(3)) \($p[1] | lpad(4)) \(abc($p[0]) | lpad(5))";

  "y = \(.a) + \(.b)x + \(.c)x^2\n",
  "  Input   Approximation",
  "  x    y     y\u0302",
   print(.z[]) ;

def x: [range(0;11)];
def y: [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321];

polynomialRegression(x; y)
| report
