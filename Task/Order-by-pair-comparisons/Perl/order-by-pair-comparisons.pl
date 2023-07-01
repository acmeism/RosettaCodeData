#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Order_by_pair_comparisons
use warnings;

sub ask
  {
  while( 1 )
    {
    print "Compare $a to $b [<,=,>]: ";
    <STDIN> =~ /[<=>]/ and return +{qw( < -1 = 0 > 1 )}->{$&};
    }
  }

my @sorted = sort ask qw( violet red green indigo blue yellow orange );
print "sorted: @sorted\n";
