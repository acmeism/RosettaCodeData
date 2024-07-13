include "bitwise" {search: "."};  # adjust as required

def leftshift($n; $width):
   [(range(0,$n)| 0), limit($width - $n; bitwise)][:$width] | to_int;

# Using a width of $width bits: x << n | x >> ($width-n)
def rotateLeft($x; $n; $width):
  $x | bitwise_or(leftshift($n; $width); rightshift($width-$n));

# Using a width of $width bits: x << n | x >> ($width-n)
def rotateRight($x; $n; $width):
  $x | bitwise_or(rightshift($n); leftshift($width-$n; $width) );

def task($x; $y):
  def isInteger: type == "number" and . == round;
  if ($x|isInteger|not) or ($y|isInteger|not) or
     $x < 0 or $y < 0 or $x > 4294967295 or $y > 4294967295
  then "Operands must be in the range of a 32-bit unsigned integer" | error
  else
    " x      = \($x)",
    " y      = \($y)",
    " x & y  = \(bitwise_and($x; $y))",
    " x | y  = \(bitwise_or($x; $y))",
    " x ^ y  = \(null | xor(x; $y))",
    "~x      = \(32 | flip($x))",
    " x << y = \($x | leftshift($y))",
    " x >> y = \($x | rightshift($y))",
    " x rl y = \(rotateLeft($x; $y; 32))",
    " x rr y = \(rotateRight($x; $y; 32))"
    end;

task(10; 2)
