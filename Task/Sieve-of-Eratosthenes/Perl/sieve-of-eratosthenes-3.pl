sub dj_vector {
  my($end) = @_;
  return @{([],[],[2],[2,3],[2,3])[$end]} if $end <= 4;
  $end-- if ($end & 1) == 0; # Ensure end is odd

  my ($sieve, $n, $limit, $s_end) = ( '', 3, int(sqrt($end)), $end >> 1 );
  while ( $n <= $limit ) {
    for (my $s = ($n*$n) >> 1; $s <= $s_end; $s += $n) {
      vec($sieve, $s, 1) = 1;
    }
    do { $n += 2 } while vec($sieve, $n >> 1, 1) != 0;
  }
  my @primes = (2);
  do { push @primes, 2*$_+1 if !vec($sieve,$_,1) } for (1..int(($end-1)/2));
  @primes;
}
