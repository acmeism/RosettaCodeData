#!/usr/bin/perl

use strict;
use warnings;

sub roman2decimal
  {
  (local $_, my $sum, my $zeros) = (shift, 0, '');
  $zeros .= 0 while
    $sum -= s/I(?=[VX])// - s/V// * 5 - s/I//g . $zeros,
    tr/MDCLX/CLXVI/;
  return $sum;
  }

print s/$/ ": " . roman2decimal($_) /er while <DATA>;

__DATA__
MCMXC
MMVIII
MDCLXVI
