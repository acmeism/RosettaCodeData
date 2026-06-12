#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Least_square
use warnings;

my $n = 1;
$n++ until $n ** 2 - ($n-1) ** 2 > 1000;
print "$n\n";
