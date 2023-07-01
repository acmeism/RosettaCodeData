sub sieve {
  my $n = shift;
  my @composite;
  for my $i (2 .. int(sqrt($n))) {
    if (!$composite[$i]) {
      for (my $j = $i*$i; $j <= $n; $j += $i) {
        $composite[$j] = 1;
      }
    }
  }
  my @primes;
  for my $i (2 .. $n) {
    $composite[$i] || push @primes, $i;
  }
  @primes;
}
