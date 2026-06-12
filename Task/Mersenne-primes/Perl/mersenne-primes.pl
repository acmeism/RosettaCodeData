use ntheory qw/forprimes is_mersenne_prime/;
forprimes { is_mersenne_prime($_) && say } 1e9;
