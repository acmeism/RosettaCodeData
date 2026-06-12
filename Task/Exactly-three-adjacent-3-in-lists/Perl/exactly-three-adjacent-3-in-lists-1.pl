#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Exactly_three_adjacent_3_in_lists
use warnings;

my @lists = (
  [9,3,3,3,2,1,7,8,5],
  [5,2,9,3,3,7,8,4,1],
  [1,4,3,6,7,3,8,3,2],
  [1,2,3,4,5,6,7,8,9],
  [4,6,8,7,2,3,3,3,1]);

for my $ref ( @lists )
  {
  my @n = grep $ref->[$_] == 3, 0 .. $#$ref;
  print "@$ref => ",
    @n == 3 && $n[0] == $n[1] - 1 && $n[1] == $n[2] - 1 ? 'true' : 'false',
    "\n";
  }
