#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Sum_of_first_n_cubes
use warnings;

my $sum = 0;
printf "%10d%s", $sum += $_ ** 3, $_ % 5 == 4 && "\n" for 0 .. 49;
