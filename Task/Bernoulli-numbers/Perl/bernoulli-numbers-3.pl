use Math::Pari qw/bernfrac/;

for my $n (0 .. 60) {
  my($num,$den) = split "/", bernfrac($n);
  printf("B(%2d) = %44s/%s\n", $n, $num, $den||1) if $num != 0;
}
