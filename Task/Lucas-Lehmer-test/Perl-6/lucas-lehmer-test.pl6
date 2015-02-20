multi is_mersenne_prime(2) { True }
multi is_mersenne_prime(Int $p) {
    my $m_p = 2 ** $p - 1;
    my $s = 4;
    #  Alternate but slightly slower:   $s = ($s * $s - 2) % $m_p  for 3..$p;
    for (3 .. $p) {
      $s = $s.expmod(2, $m_p) - 2;
      $s += $m_p if $s < 0;
    }
    $s == 0;
}

say "M$_" if is-prime($_) and is_mersenne_prime($_) for 2..*;
