use strict;
use warnings;
use feature 'state';
use ntheory 'is_prime';

my @pi = map { state $pi = 0; $pi += is_prime $_ ? 1 : 0 } 1..1e4;
do { print shift(@pi) . ' ' } until $pi[0] >= 22;
