#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Summation_of_primes
use warnings;
use ntheory qw( primes );
use List::Util qw( sum );

print sum( @{ primes( 2e6 ) } ), "\n";
