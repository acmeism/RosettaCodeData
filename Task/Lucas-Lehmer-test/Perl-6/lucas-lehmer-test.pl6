multi is_mersenne_prime(2) { True }
multi is_mersenne_prime(Int $p) {
    my $m_p = 2 ** $p - 1;
    my $s = 4;
    $s = $s.expmod(2, $m_p) - 2 for 3 .. $p;
    !$s
}

.say for (2,3,5,7 … *).hyper(:8degree).grep( *.is-prime ).map: { next unless .&is_mersenne_prime; "M$_" };
