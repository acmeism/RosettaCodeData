#!/usr/bin/perl
use strict; # https://rosettacode.org/wiki/Find_squares_n_where_n%2B1_is_prime
use warnings;
use ntheory qw( primes is_square );

my @answer = grep is_square($_), map $_ - 1, @{ primes(1000) };
print "@answer\n";
