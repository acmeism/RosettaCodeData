#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Dot_product
use warnings;
use List::AllUtils qw( sum zip_by product );

sub dotprod { return sum zip_by { product @_ } @_ }

my @vec_a = (1,3,-5);
my @vec_b = (4,-2,-1);

print dotprod(\@vec_a, \@vec_b), "\n";
