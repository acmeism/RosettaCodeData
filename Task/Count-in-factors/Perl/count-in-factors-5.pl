tie my @primes, 'Tie::SieveOfEratosthenes';

sub factors {
  my($n, $i, $p, @out) = (shift, 0, 2);
  while ($n >= $p * $p) {
    while ($n % $p == 0) {
      push @out, $p;
      $n /= $p;
    }
    $p = $primes[++$i];
  }
  push @out, $n  if $n > 1 || !@out;
  @out;
}

print "$_ = ", join(" x ", factors($_)), "\n" for 100000000000 .. 100000000010;
