use Math::GMP qw/:constant/;

sub is_prime { Math::GMP->new(shift)->probab_prime(12); }

sub is_mersenne_prime {
  my $p = shift;
  return 1 if $p == 2;
  my $mp = 2 ** $p - 1;
  my $s = 4;
  $s = ($s * $s - 2) % $mp  for 3..$p;
  $s == 0;
}

foreach my $p (2 .. 43_112_609) {
  print "M$p\n" if is_prime($p) && is_mersenne_prime($p);
}
