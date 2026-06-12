#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Prime_numbers_p_which_sum_of_prime_numbers_less_or_equal_to_p_is_prime
use warnings;
use ntheory qw( is_prime primes vecsum );

print "@{[ grep is_prime( vecsum( @{ primes($_) } ) ), @{ primes(1000) } ]}\n";
