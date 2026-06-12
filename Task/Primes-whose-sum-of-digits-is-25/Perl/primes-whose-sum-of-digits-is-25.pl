use strict;
use warnings;
use feature 'say';
use List::Util 'sum';
use ntheory 'is_prime';

my($limit, @p25) = 5000;
is_prime($_) and 25 == sum(split '', $_) and push @p25, $_ for 1..$limit;
say @p25 . " primes < $limit with digital sum 25:\n" . join ' ', @p25;
