sub sieve2 {
  my($n) = @_;
  return @{([],[],[2],[2,3],[2,3])[$n]} if $n <= 4;

  my @composite;
  for (my $t = 3;  $t*$t <= $n;  $t += 2) {
     if (!$composite[$t]) {
        for (my $s = $t*$t;  $s <= $n;  $s += $t*2)
           { $composite[$s]++ }
     }
  }
  my @primes = (2);
  for (my $t = 3;  $t <= $n;  $t += 2) {
     $composite[$t] || push @primes, $t;
  }
  @primes;
}
