#!/usr/bin/perl

use strict;
use warnings;
use ntheory qw( is_prime twin_primes );

is_prime($_ - 4) and printf "%5d" x 4 . "\n", $_ - 3, $_ - 4, $_, $_ + 2
  for @{ twin_primes( 6000 ) };
