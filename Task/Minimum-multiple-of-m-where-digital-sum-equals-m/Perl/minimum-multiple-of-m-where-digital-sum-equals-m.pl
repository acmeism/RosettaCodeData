#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Minimum_multiple_of_m_where_digital_sum_equals_m
use warnings;
use ntheory qw( sumdigits );

my @answers = map
  {
  my $m = 1;
  $m++ until sumdigits($m*$_) == $_;
  $m;
  } 1 .. 70;
print "@answers\n\n" =~ s/.{65}\K /\n/gr;
