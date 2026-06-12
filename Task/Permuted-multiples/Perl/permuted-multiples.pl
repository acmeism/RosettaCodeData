#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Permuted_multiples
use warnings;

my $n = 3;
1 while do {
  length($n += 3) < length 6 * $n and $n = 1 . $n =~ s/./0/gr + 2;
  my $sorted = join '', sort split //, $n * 6;
  $sorted ne join '', sort split //, $n * 1 or
  $sorted ne join '', sort split //, $n * 2 or
  $sorted ne join '', sort split //, $n * 3 or
  $sorted ne join '', sort split //, $n * 4 or
  $sorted ne join '', sort split //, $n * 5
  };
printf " n  %s\n", $n;
printf "%dn  %s\n", $_ , $n * $_ for 2 .. 6;
