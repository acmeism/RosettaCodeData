#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/L-system
use warnings;

sub lsystem
  {
  my ($string, $rules) = @_;
  my $keys = join '|', keys %$rules;
  $string =~ s/$keys/$rules->{$&}/gr;
  }

print my $string = 'I';
print $string = lsystem $string, {I=>'M',M=>'MI'} for 1 .. 5;
