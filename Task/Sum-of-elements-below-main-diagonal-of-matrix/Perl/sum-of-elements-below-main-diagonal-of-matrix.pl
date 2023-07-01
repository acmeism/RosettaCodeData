#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw( sum );

my $matrix =
  [[1,3,7,8,10],
  [2,4,16,14,4],
  [3,1,9,18,11],
  [12,14,17,18,20],
  [7,1,3,9,5]];

my $lowersum = sum map @{ $matrix->[$_] }[0 .. $_ - 1], 1 .. $#$matrix;
print "lower sum = $lowersum\n";
