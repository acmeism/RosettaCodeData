#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Product_of_divisors
use warnings;

my @products = ( 1 ) x 51;
for my $n ( 1 .. 50 )
  {
  $n % $_ or $products[$n] *= $_ for 1 .. $n;
  }
printf '' . (('%11d' x 5) . "\n") x 10, @products[1 .. 50];
