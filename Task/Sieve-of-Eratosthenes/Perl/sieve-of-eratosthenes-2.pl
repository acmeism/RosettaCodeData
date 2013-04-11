sub simple_sieve {
  my($max) = @_;
  return () if $max < 2;  return (2) if $max < 3;

  my @c;
  for(my $t=3; $t*$t<=$max; $t+=2) {
     if (!$c[$t]) {
         for(my $s=$t*$t; $s<=$max; $s+=$t*2) { $c[$s]++ }
     }
  }
  my @primes = (2);
  for(my $t=3; $t<=$max; $t+=2) {
      $c[$t] || push @primes, $t;
  }
  @primes;
}
