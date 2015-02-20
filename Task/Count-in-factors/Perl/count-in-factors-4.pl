sub factors {
  my($n, $p, @out) = (shift, 3);
  return if $n < 1;
  while (!($n&1)) { $n >>= 1; push @out, 2; }
  while ($n > 1 && $p*$p <= $n) {
    while ( ($n % $p) == 0) {
      $n /= $p;
      push @out, $p;
    }
    $p += 2;
  }
  push @out, $n if $n > 1;
  @out;
}

print "$_ = ", join(" x ", factors($_)), "\n" for 100000000000 .. 100000000100;
