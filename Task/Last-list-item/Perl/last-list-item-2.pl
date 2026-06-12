#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Last_list_item
use warnings;
use List::AllUtils qw( sum min extract_first_by );

my @list = <6 81 243 14 25 49 123 69 11>;
print "@list\n";
push @list, sum
  map { my $min = min @list; extract_first_by { $_ == $min } @list } 1, 2
  and print "@list\n" while @list > 1;
