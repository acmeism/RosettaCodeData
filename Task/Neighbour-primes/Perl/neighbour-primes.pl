use strict;
use warnings;
use ntheory <next_prime is_prime>;

my $p = 2;
do {
    my $q = next_prime($p);
    printf "%3d%5d%8d\n", $p, $q, $p*$q+2 if is_prime $p*$q+2;
    $p = $q;
} until $p >= 500;
