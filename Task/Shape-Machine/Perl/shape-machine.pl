#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Shape-Machine#
use warnings;

my $n = 4;
my $count = 0;
my $prev = 0;
while( $n != $prev )
  {
  $prev = $n;
  $n = sprintf "%.50f", ($n + 3) * 0.86;
  print "$n\n";
  $count++;
  }
print "Iterations: $count\n";
