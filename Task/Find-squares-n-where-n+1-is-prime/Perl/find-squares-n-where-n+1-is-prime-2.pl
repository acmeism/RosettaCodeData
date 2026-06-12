use strict;
use warnings;
use feature 'say';
use ntheory 'is_prime';

my $a; is_prime $_ and $a = sqrt $_-1 and $a == int $a and say $_-1 for 1..1000; # backwards approach
my $b; do { say $b**2 if is_prime 1 + ++$b**2 } until $b > int sqrt 1000;        # do/until
my $c; while (++$c < int sqrt 1000) { say $c**2 if is_prime 1 + $c**2 }          # while/if
say for map $_**2, grep is_prime 1 + $_**2, 1 .. int sqrt 1000;                  # for/map/grep
for (1 .. int sqrt 1000) { say $_**2 if is_prime 1 + $_**2 }                     # for/if
say $_**2 for grep is_prime 1 + $_**2, 1 .. int sqrt 1000;                       # for/grep
is_prime 1 + $_**2 and say $_**2 for 1 .. int sqrt 1000;                         # and/for
is_prime 1+$_**2&&say$_**2for 1..31;                                             # and/for golf, FTW

# or dispense with the module and find primes the slowest way possible
(1 x (1+$_**2)) !~ /^(11+)\1+$/ and say $_**2 for 1 .. int sqrt 1000;
