sub getmapper(Range $a, Range  $b) {
  my ($a1, $a2) = $a.bounds;
  my ($b1, $b2) = $b.bounds;
  return -> $s { $b1 + (($s-$a1) * ($b2-$b1) / ($a2-$a1)) }
}

my &mapper = getmapper(0 .. 10, -1 .. 0);
for ^11 -> $x {say "$x maps to &mapper($x)"}
