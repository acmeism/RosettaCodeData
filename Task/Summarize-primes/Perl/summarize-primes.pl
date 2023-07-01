use strict;
use warnings;
use ntheory <nth_prime is_prime>;

my($n, $s, $limit, @sums) = (0, 0, 1000);
do {
    push @sums, sprintf '%3d %8d', $n, $s if is_prime($s += nth_prime ++$n)
} until $n >= $limit;

print "Of the first $limit primes: @{[scalar @sums]} cumulative prime sums:\n", join "\n", @sums;
