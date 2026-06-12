#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Pandigital_prime
use warnings;
use ntheory qw( forperm is_prime );

for my $digits ( reverse 1 .. 9 )
  {
  forperm
    {
    my $n = join '', map $digits - $_, @_;
    is_prime($n) and exit ! print "$n\n";
    } $digits;
  }
