#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Prime_numbers_of_measurement
use warnings;

my ($ruler, $n, @marks) = (11, 0, 1);
$n++, $ruler =~ /1.{$n}1/ or $ruler .= ' ' x $n . 1, push @marks, $n + 1
  while @marks < 1000;
print sprintf +('%5d' x 10 . "\n") x 10, @marks[0 .. 99];
print "\n1000th element: $marks[999]\n";
