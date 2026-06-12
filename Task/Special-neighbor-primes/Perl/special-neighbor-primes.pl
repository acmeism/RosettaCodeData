#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Special_neighbor_primes
use warnings;
use ntheory qw( primes is_prime );

my @primes = @{ primes(100) };
for ( 1 .. $#primes )
  {
  is_prime( $@ = $primes[$_-1] + $primes[$_] - 1 ) and
    printf "%2d + %2d - 1 = %3d\n", $primes[$_-1], $primes[$_], $@;
  }
