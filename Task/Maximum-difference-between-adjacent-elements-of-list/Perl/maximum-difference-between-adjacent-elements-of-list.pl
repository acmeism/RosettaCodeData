#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw( reduce max );

my @list = (1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3);

my %diffs;
reduce { $diffs{ abs $a - $b } .= " $a,$b"; $b } @list;
my $max = max keys %diffs;
print "$_ ==> $max\n" for split ' ', $diffs{ $max };
