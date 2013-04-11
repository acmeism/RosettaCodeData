multi is_prime(2) { True }
multi is_prime(Int $p) { $p %% none(2,3,5,7...^ * > sqrt($p)) }

multi is_mersenne_prime(2) { True }
multi is_mersenne_prime(Int $p) {
    my $m_p = 2 ** $p - 1;
    my $s = 4;
    $s = ($s ** 2 - 2) % $m_p for 3 .. $p;
    $s == 0;
}

say "M$_" if is_prime($_) and is_mersenne_prime($_) for 2..*;
