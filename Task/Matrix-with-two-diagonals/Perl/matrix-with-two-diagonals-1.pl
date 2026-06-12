#!/usr/bin/perl

use strict; #https://rosettacode.org/wiki/Matrix_with_two_diagonals
use warnings;

print diagonal($_), "\n" for 10, 11;

sub diagonal
  {
  my $n =  shift() - 1;
  local $_ = 1 . 0 x ($n - 1) . 2 . "\n" . (0 . 0 x $n . "\n") x $n;
  1 while s/(?<=1...{$n})0/1/s or s/(?<=2.{$n})[01]/2/s;
  return tr/2/1/r =~ s/\B/ /gr;
  }
