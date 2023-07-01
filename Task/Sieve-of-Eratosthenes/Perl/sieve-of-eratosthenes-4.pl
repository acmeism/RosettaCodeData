sub string_sieve {
  my ($n, $i, $s, $d, @primes) = (shift, 7);

  local $_ = '110010101110101110101110111110' .
             '101111101110101110101110111110' x ($n/30);

  until (($s = $i*$i) > $n) {
    $d = $i<<1;
    do { substr($_, $s, 1, '1') } until ($s += $d) > $n;
    1 while substr($_, $i += 2, 1);
  }
  $_ = substr($_, 1, $n);
  # For just the count:  return ($_ =~ tr/0//);
  push @primes, pos while m/0/g;
  @primes;
}
