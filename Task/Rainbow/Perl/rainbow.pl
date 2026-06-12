#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Rainbow
use warnings;
use List::AllUtils qw( zip_by );

print zip_by { "\e[38;2;$_[1]m$_[0]\e[m" } [ split //, 'RAINBOW' ],
  [qw( 255;0;0 255;128;0 255;255;0 0;255;0 0;0;255 75;0;130 128;0;255 )];
print "\n";
