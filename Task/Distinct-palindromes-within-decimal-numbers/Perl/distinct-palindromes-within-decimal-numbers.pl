#!/usr/bin/perl

# https://rosettacode.org/wiki/Distinct_Palindromes_Within_Decimal_Numbers
use strict;
use warnings;

for ( 100 .. 125 )
  {
  my %found;
  /.+(?{$& eq reverse $& and $found{$&}++})(*FAIL)/;
  print "$_ => @{[ sort { $a <=> $b } keys %found ]}\n"
  }

/..+(??{$& == (reverse $&) ? '' : '(*FAIL)' })/ and
  print "$_ has a palindrome of 2 or more\n"
  for ' 9, 169, 12769, 1238769, 123498769, 12346098769, 1234572098769,
    123456832098769, 12345679432098769, 1234567905432098769,
    123456790165432098769, 83071934127905179083, 1320267947849490361205695'
    =~ /\d+/g;
