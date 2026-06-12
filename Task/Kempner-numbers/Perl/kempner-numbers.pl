#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Kempner_numbers
use warnings;
use ntheory qw( factorial );
use List::AllUtils qw( first );

my @k = map { my $n = $_; first { factorial($_) % $n == 0 } 1 .. $n } 1 .. 50;
print sprintf('%5d' x @k, @k) =~ s/.{50}\K/\n/gr;
