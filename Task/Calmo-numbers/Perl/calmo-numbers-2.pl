#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Calmo_numbers
use warnings;
use List::AllUtils qw( all bundle_by sum );
use ntheory qw( is_prime divisors );

my @calmo = grep {
  my @div = divisors $_;
  @div >= 5 and @div % 3 == 2 and
    all { is_prime $_ } bundle_by { sum @_ } 3, splice @div, 1, -1
  } 1 .. 999;
print "@calmo\n";
