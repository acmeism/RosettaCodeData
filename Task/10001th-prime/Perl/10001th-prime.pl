use strict;
use warnings;
use feature 'say';

# the lengthy wait increases the delight in finally seeing the answer
my($n,$c) = (1,0);
while () {
    $c++ if (1 x ++$n) !~ /^(11+)\1+$/;
    $c == 10_001 and say $n and last;
}

# or if for some reason you want the answer quickly
use ntheory 'nth_prime';
say nth_prime(10_001);
