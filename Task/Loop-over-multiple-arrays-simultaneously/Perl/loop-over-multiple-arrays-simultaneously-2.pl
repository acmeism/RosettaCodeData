#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Loop_over_multiple_arrays_simultaneously
use warnings;
use List::AllUtils qw( zip_by );

my @data1 = qw( a b c);
my @data2 = qw( A B C D E);
my @data3 = qw( 1 2 3 4 );

for ( zip_by { join '', map $_//' ', @_ } \@data1, \@data2, \@data3 )
  {
  print "$_\n";
  }
