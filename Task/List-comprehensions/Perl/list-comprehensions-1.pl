sub triples ($) {
  my ($n) = @_;
  map { my $x = $_; map { my $y = $_; map { [$x, $y, $_] } grep { $x**2 + $y**2 == $_**2 } 1..$n } 1..$n } 1..$n;
}
