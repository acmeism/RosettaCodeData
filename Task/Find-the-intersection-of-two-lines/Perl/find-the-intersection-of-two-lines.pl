sub intersect {
  my ($x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4) = @_;
  my $a1 = $y2 - $y1;
  my $b1 = $x1 - $x2;
  my $c1 = $a1 * $x1 + $b1 * $y1;
  my $a2 = $y4 - $y3;
  my $b2 = $x3 - $x4;
  my $c2 = $a2 * $x3 + $b2 * $y3;
  my $delta = $a1 * $b2 - $a2 * $b1;
  return (undef, undef) if $delta == 0;
  # If delta is 0, i.e. lines are parallel then the below will fail
  my $ix = ($b2 * $c1 - $b1 * $c2) / $delta;
  my $iy = ($a1 * $c2 - $a2 * $c1) / $delta;
  return ($ix, $iy);
}

my ($ix, $iy) = intersect(4, 0, 6, 10, 0, 3, 10, 7);
print "$ix $iy\n";
($ix, $iy) = intersect(0, 0, 1, 1, 1, 2, 4, 5);
print "$ix $iy\n";
