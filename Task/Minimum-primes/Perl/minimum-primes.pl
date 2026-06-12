#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Minimum_primes
use warnings;
use ntheory qw( next_prime );
use List::Util qw( max );

my @Numbers1 = (5,45,23,21,67);
my @Numbers2 = (43,22,78,46,38);
my @Numbers3 = (9,98,12,54,53);

my @Primes = map {
  next_prime( max( $Numbers1[$_], $Numbers2[$_], $Numbers3[$_] ) - 1 )
  } 0 .. 4;

print "@Primes\n";
