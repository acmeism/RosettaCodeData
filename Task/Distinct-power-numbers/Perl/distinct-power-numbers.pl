#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/Distinct_power_numbers
use warnings;
use List::Util qw( uniq );

print join ', ', sort { $a <=> $b } uniq map { my $e = $_; map $_ ** $e, 2 .. 5} 2 .. 5;
