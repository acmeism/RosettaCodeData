#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Decreasing_contiguous_subsequences
use warnings;
use List::Util qw( reduce );

my @data = map /\d+/g, do { local @ARGV = 'd.decreasingsubsequence'; <> };
my @groups = [ $data[0] ];
reduce { $a < $b ? push @groups, [$b] : push @{$groups[-1]}, $b; $b } @data;
my @counts = map 0, my @bin = (0, 4, 8, 12, 16, 25, 100);
for ( @groups )
  {
  my $percent = 100 * ($_->[0] - $_->[-1]) / $_->[0] or next;
  $counts[ $#bin - grep $percent < $_, @bin ]++;
  }
reduce { printf "%3s .. %-3s -> %d\n", $a, $b, shift @counts; $b } @bin;
