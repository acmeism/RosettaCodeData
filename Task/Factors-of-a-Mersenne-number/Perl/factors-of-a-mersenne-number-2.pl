use Math::GMP;

# Use GMP's simple probable prime test.
sub is_prime { Math::GMP->new(shift)->probab_prime(20); }

# Lucas-Lehmer test, deterministic for 2^p-1 given p
sub is_mersenne_prime {
  my($p, $mp, $s) = ($_[0], Math::GMP->new(2)**$_[0]-1, Math::GMP->new(4));
  return 1 if $p == 2;
  $s = ($s * $s - 2) % $mp  for 3 .. $p;
  $s == 0;
}

for my $p (2 .. 100, 929) {
  next unless is_prime($p);
  my $mp = Math::GMP->new(2) ** $p - 1;
  my $lim = $mp->bsqrt();
  $lim = 1000000 if $lim > 1000000;   # We're using it as a pre-test
  my $factor;
  for (my $q = Math::GMP->new(2*$p+1);  $q <= $lim && !$factor;  $q += 2*$p) {
    next unless ($q & 7) == 1 || ($q & 7) == 7;
    next unless is_prime($q);
    $factor = $q if Math::GMP->new(2)->powm_gmp($p,$q) == 1;  #  $mp % $q == 0
  }
  if ($factor) {
    print "M$p = $factor * ",$mp/$factor,"\n";
  } else {
    print "M$p is ", is_mersenne_prime($p) ? "prime" : "composite", "\n";
  }
}
