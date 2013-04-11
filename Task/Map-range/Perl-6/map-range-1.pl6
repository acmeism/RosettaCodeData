use v6;
# Author: P. Seebauer
sub the_function(Range $a, Range  $b, $s ) {
  my ($a1, $a2, $b1, $b2) = ($a, $b)».bounds;
  return $b1 + (($s-$a1) * ($b2-$b1) / ($a2-$a1));
}

for ^11 -> $x {say "$x maps to {the_function(0..10,-1..0, $x)}"}
