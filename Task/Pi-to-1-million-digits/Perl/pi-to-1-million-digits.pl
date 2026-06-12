#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Pi_to_1_Million_Digits
use warnings;
use ntheory qw( Pi );
use Time::HiRes qw( time );

my $start = time;
my $pi = Pi(1e6);
my $took = time - $start;
printf "Pi = %s\n\nPi calculation took %.3f seconds\n",
  $pi =~ s/(.{30}).*(.{30})/$1...$2/r, $took;
