#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Magic_constant
use warnings;

my @twenty = map $_ * ( $_ ** 2 + 1 ) / 2, 3 .. 22;
print "first twenty: @twenty\n\n" =~ s/.{50}\K /\n/gr;

my $thousandth = 1002 * ( 1002 ** 2 + 1 ) / 2;
print "thousandth: $thousandth\n\n";

print "10**N   order\n";
for my $i ( 1 .. 20 )
  {
  printf "%3d %9d\n", $i, (10 ** $i * 2) ** ( 1 / 3 ) + 1;
  }
