#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Show_the_(decimal)_value_of_a_number_of_1s_appended_with_a_3,_then_squared
use warnings;
#use bignum; # uncomment for larger than 9 or 32-bit perls

for ( 0 .. 7 )
  {
  my $number = 1 x $_ . 3;
  print "$number  ", $number ** 2, "\n";
  }
