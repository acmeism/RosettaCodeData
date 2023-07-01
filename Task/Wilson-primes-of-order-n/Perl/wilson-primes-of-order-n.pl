use strict;
use warnings;
use ntheory <primes factorial>;

my @primes = @{primes( 10500 )};

for my $n (1..11) {
    printf "%3d: %s\n", $n, join ' ', grep { $_ >= $n && 0 == (factorial($n-1) * factorial($_-$n) - (-1)**$n) % $_**2 } @primes
}
