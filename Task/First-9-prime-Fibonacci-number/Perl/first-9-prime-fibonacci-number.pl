#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/First_9_Prime_Fibonacci_Number
use warnings;
use ntheory qw( is_prime );

my @first;
my $x = my $y = 1;
while( @first < 9 )
  {
  ($x, $y) = ($x + $y, $x);
  is_prime( $x ) and push @first, $x;
  }
print "@first\n";
