#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Minimum_numbers_of_three_lists
use warnings;
use List::AllUtils qw( zip_by min );

my @lists = ([5,45,23,21,67], [43,22,78,46,38], [9,98,12,98,53]);
my @newlist = zip_by { min @_ } @lists;
print "@newlist\n";
