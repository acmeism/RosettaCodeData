use strict;
use warnings;
use Primesieve qw(generate_primes);

for my $n (2..8) {
    my @primes = generate_primes (1, 10**$n);
    my($max,$p,$diff) = 0;
    map { ($diff = $primes[$_] - $primes[$_-1]) > $max and ($max,$p) = ($diff,$_-1) } 1..$#primes;
    printf "Largest prime gap up to %d: %d - between %d and %d.\n", 10**$n, $max, @primes[$p,$p+1];
}
