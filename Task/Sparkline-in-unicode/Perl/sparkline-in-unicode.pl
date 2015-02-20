binmode(STDOUT, ":utf8");

sub sparkline {
  my $s = shift;
  my @n = split(/[\s,]+/,$s);
  return unless @n;
  my($min,$max) = ($n[0],$n[0]);
  for my $v (@n) { $min = $v if $v < $min; $max = $v if $v > $max; }
  printf "min: %5f; max %5f\n", $min, $max;
  my @bars = map { chr($_) } 0x2581 .. 0x2588;
  my $div = ($max - $min) / $#bars;
  print join("", map { $bars[$div ? ($_-$min) / $div : @bars/2] } @n), "\n";
  1;
}

while (1) {
  print "Numbers separated by spaces/commas: ";
  exit unless sparkline(scalar(<>));
}
