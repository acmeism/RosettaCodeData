use ntheory qw/bernfrac/;

for my $n (0 .. 60) {
  my($num,$den) = bernfrac($n);
  printf "B(%2d) = %44s/%s\n", $n, $num, $den if $num != 0;
}
