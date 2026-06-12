#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Passphrase_generator
use warnings;

sub genpp
  {
  use List::AllUtils qw( sample );
  my $n = shift // 5;
  local( @ARGV, $/) = 'unixdict.txt';
  join '-', map "\u$_" . int rand 100, sample $n, <> =~ /^[a-z]{4,9}$/gm;
  }

print genpp($_), "\n" for 3 .. 9;
