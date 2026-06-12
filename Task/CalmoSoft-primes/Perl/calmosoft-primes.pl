use strict;
use warnings;
use ntheory <primes is_prime vecsum>;

for my $limit (<100 250 500 1000>) {
    my @primes = @{ primes(2,$limit) };
    T: for my $terms (reverse 1 .. @primes) {
        for my $i (0 .. @primes-$terms) {
            my @primes = @primes[$i..($i+$terms)-1];
            next unless is_prime (my $sum = vecsum @primes);
            print "For primes up to $limit:\n",
                  join ' ... ', join(' + ',@primes[0..5]), join(' + ',@primes[-5..-1]) . " = $sum ($terms primes)\n\n";
            last T
        }
    }
}
