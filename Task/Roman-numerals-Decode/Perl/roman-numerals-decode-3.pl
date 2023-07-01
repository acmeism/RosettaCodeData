#!/usr/bin/perl

use strict;
use warnings;

sub roman2decimal
  {
  my $sum = 0;
  $sum += $^R while $_[0] =~
    / M  (?{1000})
    | D  (?{ 500})
    | C  (?{ 100}) (?= [MD] (?{-100}) )?
    | L  (?{  50})
    | X  (?{  10}) (?= [CL] (?{ -10}) )?
    | V  (?{   5})
    | I  (?{   1}) (?= [XV] (?{  -1}) )?
    /gx;
  return $sum;
  }

print s/$/ ": " . roman2decimal($_) /er while <DATA>;

__DATA__
MCMXC
MMVIII
MDCLXVI
