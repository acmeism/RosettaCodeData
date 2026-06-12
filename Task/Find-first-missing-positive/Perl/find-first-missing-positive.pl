#!/usr/bin/perl -l

use strict;
use warnings;
use List::Util qw( first );

my @tests = ( [1,2,0], [3,4,-1,1], [7,8,9,11,12],
  [3, 4, 1, 1], [1, 2, 3, 4, 5], [-6, -5, -2, -1], [5, -5], [-2], [1], []);

for my $test ( @tests )
  {
  print "[ @$test ]  ==>  ",
    first { not { map { $_ => 1 } @$test }->{$_}  } 1 .. @$test + 1;
  }
