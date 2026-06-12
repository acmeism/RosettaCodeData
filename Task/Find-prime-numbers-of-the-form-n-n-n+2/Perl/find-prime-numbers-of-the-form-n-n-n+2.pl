use strict;
use warnings;
use feature 'say';

use Math::AnyNum ':all'; # in order to handle large values

# basic task results
say join ' ', grep { is_prime $_ } map { $_**3 + 2 } grep { 0 != $_%2 } 1..199;

# generalize a bit, how many primes over a range of exponents and offsets?

say '   ' . sprintf '%4d'x11 , 1..10;
for my $e (1..10) {
  printf  '%2d ', $e;
  for my $o (1..10) {
    printf  '%4d', scalar grep { is_prime $_ } map { $_**$e + $o } 1..199;
  }
  print "\n";
}
