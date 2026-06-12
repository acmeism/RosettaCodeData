#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/L-system
use feature 'signatures';
use warnings;

sub lsystem ($string, $rules)
  {
  $string =~ s!.!$rules->{$&}//$&!ger;
  }

print my $string = 'I';
print $string = lsystem $string, {I=>'M',M=>'MI'} for 1 .. 5;
