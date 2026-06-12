#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Round-robin_tournament_schedule
use warnings;

my $n = 12;
my @teams = 1 .. $n;
for (1 .. $n-1)
  {
  @teams[0,$n-1,1..$n-2] = @teams;
  printf 'Round %2d:' . '%4d vs %2d'x($n/2) . "\n", $_, @teams[ map { $_, $n-1-$_} 0..($n/2)-1 ];
  }
