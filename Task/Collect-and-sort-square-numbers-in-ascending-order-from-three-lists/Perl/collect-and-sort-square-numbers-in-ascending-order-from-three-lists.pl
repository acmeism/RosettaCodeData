#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Add_and_sort_square_numbers_in_ascending_order_from_three_lists
use warnings;
use ntheory qw( is_square );
use List::Util qw( sum );

my @lists = (
  [3,4,34,25,9,12,36,56,36],
  [2,8,81,169,34,55,76,49,7],
  [75,121,75,144,35,16,46,35]);

my $sum = sum my @squares = grep is_square($_), sort { $a <=> $b } map @$_, @lists;
print "sum $sum  -  @squares\n";
