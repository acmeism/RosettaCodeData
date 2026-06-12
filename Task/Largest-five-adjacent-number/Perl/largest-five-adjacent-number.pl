#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Largest_five_adjacent_number
use warnings;

$_ = join '', map int rand 10, 1 .. 1e3;
my @n;
@n[ /(?=(\d{5}))/g ] = ();
print "$#n\n";
