#!/usr/bin/perl

use strict;
use warnings;
use ntheory qw( is_prime twin_primes );

is_prime($_ + 6) and printf "%5d" x 3 . "\n", $_, $_ + 2, $_ + 6
  for @{ twin_primes( 5500 ) };
