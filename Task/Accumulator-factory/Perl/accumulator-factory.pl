sub accumulator {
  my $sum = shift;
  sub { $sum += shift }
}

my $x = accumulator(1);
$x->(5);
accumulator(3);
print $x->(2.3), "\n";
