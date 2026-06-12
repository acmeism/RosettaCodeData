#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Decorate-sort-undecorate_idiom
use warnings;
use List::AllUtils qw( nsort_by );

my @list = ("Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site");
print "@list\n";

my @sortedlist = nsort_by { length } @list;
print "@sortedlist\n";
