sub invmod {
  my($a,$n) = @_;
  my($t,$nt,$r,$nr) = (0, 1, $n, $a % $n);
  while ($nr != 0) {
    # Use this instead of int($r/$nr) to get exact unsigned integer answers
    my $quot = int( ($r - ($r % $nr)) / $nr );
    ($nt,$t) = ($t-$quot*$nt,$nt);
    ($nr,$r) = ($r-$quot*$nr,$nr);
  }
  return if $r > 1;
  $t += $n if $t < 0;
  $t;
}

say invmod(42,2017);
