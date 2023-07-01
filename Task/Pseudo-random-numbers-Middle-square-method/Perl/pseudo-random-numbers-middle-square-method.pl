#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Pseudo-random_numbers/Middle-square_method
use warnings;

sub msq
  {
  use feature qw( state );
  state $seed = 675248;
  $seed = sprintf "%06d", $seed ** 2 / 1000 % 1e6;
  }

print msq, "\n" for 1 .. 5;
