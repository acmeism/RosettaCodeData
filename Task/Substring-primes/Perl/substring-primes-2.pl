#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Substring_primes
use warnings;
use ntheory qw( is_prime primes );

my $pattern = join '|', grep !is_prime($_), 1 .. 500;
my @primes = grep !/$pattern/, @{ primes( 500 ) };
print "@primes\n";
