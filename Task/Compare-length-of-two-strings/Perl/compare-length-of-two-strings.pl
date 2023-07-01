#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Compare_length_of_two_strings
use warnings;

for ( 'shorter thelonger', 'abcd 123456789 abcdef 1234567' )
  {
  print "\nfor strings => $_\n";
  printf "length %d: %s\n", length(), $_
    for sort { length $b <=> length $a } split;
  }
