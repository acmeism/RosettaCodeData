#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Two_identical_strings
use warnings;

while( 1 )
  {
  my $binary = ( sprintf "%b", ++$- ) x 2;
  (my $decimal = oct "b$binary") >= 1000 and last;
  printf "%4d  %s\n", $decimal, $binary;
  }
