use strict;
use warnings;
use List::Util 'sum';
use ntheory <primes is_prime>;
use Algorithm::Combinatorics 'combinations';

for my $n (30, 1000) {
    printf "Found %d strange unique prime triplets up to $n.\n",
        scalar grep { is_prime(sum @$_) } combinations(primes($n), 3);
}
