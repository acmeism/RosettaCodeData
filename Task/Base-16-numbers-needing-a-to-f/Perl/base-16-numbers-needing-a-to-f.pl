#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Base-16_representation
use warnings;

print join( ' ', grep sprintf("%x", $_) =~ tr/a-z//, 1 .. 500 ) =~
  s/.{71}\K /\n/gr, "\n";
