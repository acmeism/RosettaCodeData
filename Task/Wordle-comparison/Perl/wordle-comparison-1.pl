#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Wordle_comparison
use warnings;

for my $test ( ["ALLOW", "LOLLY"], ["BULLY", "LOLLY"], ["ROBIN", "ALERT"],
  ["ROBIN", "SONIC"], ["ROBIN", "ROBIN"])
  {
  local $_ = join "\n", @$test;
  1 while s/([ -~])(.*\n(??{$` =~ tr!!.!cr}))\1/\0$2\0/;
  1 while s/([ -~])(.*\n.*?)\1/\01$2\01/;
  print "@$test => @{[ qw( green yellow grey )
    [map ord, split //, s/.*\n//r =~ tr/\0\1/\2/cr] ]}\n";
  }
