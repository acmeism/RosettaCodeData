#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Numbers_k_whose_divisor_sum_is_equal_to_the_divisor_sum_of_k_%2B_1
use warnings;

my ($n, @div, $k) = (500000, 0);
for my $mod ( 1 .. $n )
  {
  $div[$mod * $_] += $mod for 1 .. $n / $mod;
  $div[$mod - 1] == $div[$mod] and $k .= sprintf '%8d', $mod - 1;
  }
print $k =~ s/.{1,80}\K/\n/gr;
