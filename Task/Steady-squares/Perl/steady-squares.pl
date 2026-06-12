#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Steady_Squares
use warnings;

($_ ** 2) =~ /$_$/ and printf "%5d  %d\n", $_, $_ ** 2 for 1 .. 10000;
