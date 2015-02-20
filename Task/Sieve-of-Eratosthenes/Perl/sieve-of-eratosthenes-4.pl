sub dj_string {
  my($end) = @_;
  return @{([],[],[2],[2,3],[2,3])[$end]} if $end <= 4;
  $end-- if ($end & 1) == 0;
  my $s_end = $end >> 1;

  my $whole = int( ($end>>1) / 15);    # prefill with 3 and 5 marked
  my $sieve = '100010010010110' . '011010010010110' x $whole;
  substr($sieve, ($end>>1)+1) = '';
  my ($n, $limit, $s) = ( 7, int(sqrt($end)), 0 );
  while ( $n <= $limit ) {
    for ($s = ($n*$n) >> 1; $s <= $s_end; $s += $n) {
      substr($sieve, $s, 1) = '1';
    }
    do { $n += 2 } while substr($sieve, $n>>1, 1);
  }
  # If you just want the count, it's very fast:
  #       my $count = 1 + $sieve =~ tr/0//;
  my @primes = (2, 3, 5);
  ($s, $n) = (3, 7-2);
  while ( (my $nexts = 1 + index($sieve, "0", $s)) > 0 ) {
    $n += 2 * ($nexts - $s);
    $s = $nexts;
    push @primes, $n;
  }
  @primes;
}
