use strict;
use warnings;
use feature 'say';
use ntheory <nth_prime primes>;
use List::MoreUtils qw(slide);

# build adding one term at a time
my(@F,$n);
do { ++$n and push @F, nth_prime($n) * nth_prime($n+1) - (nth_prime($n) + nth_prime($n+1)) } until $F[-1] >= 10000;
say "$#F matching numbers:\n" . join(' ', @F[0 .. $#F-1]);

# process a list with a 2-wide sliding window
my $limit = 10_000;
say "\n" . join ' ', grep { $_ < $limit } slide { $a * $b - $a - $b } @{primes($limit)};
