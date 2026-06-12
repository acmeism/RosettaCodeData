#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Sum_of_square_and_cube_digits_of_an_integer_are_primes
use warnings;
use ntheory qw( is_prime vecsum );

my @results = grep
  is_prime( vecsum( split //, $_ ** 2 ) ) &&
  is_prime( vecsum( split //, $_ ** 3 ) ), 1 .. 100;
print "@results\n";
