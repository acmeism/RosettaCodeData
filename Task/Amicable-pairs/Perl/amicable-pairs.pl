use ntheory qw/divisor_sum/;
for my $x (1..20000) {
  my $y = divisor_sum($x)-$x;
  say "$x $y" if $y > $x && $x == divisor_sum($y)-$y;
}
