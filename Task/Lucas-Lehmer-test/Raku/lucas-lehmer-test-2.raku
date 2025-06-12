multi is_mersenne_prime(2) { True }
multi is_mersenne_prime(Int $p) {
    my $m_p = 1 +< $p - 1;
    my $s = 4;
    $s = $s.expmod(2, $m_p) - 2 for 3 .. $p;
    !$s
}

# Exhaustive search for Mersenne primes up to 4600 - about half a second
my $start = now;
.say for (flat 2, (1..2300).map(* * 2 + 1)).hyper.map:
  { next unless .&is-prime && .&is_mersenne_prime; "M$_ {(now - $start).round(.001)} running total seconds" };

# Cheat and just verify Mersenne primes > 4600
.say for (9689, 9941, 11213, 19937, 21701, 23209, 44497, 86243, 110503).hyper(:1batch).map:
  { next unless .&is_mersenne_prime; "M$_ {(now - $start).round(.001)} running total seconds" };
