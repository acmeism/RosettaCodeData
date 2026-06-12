#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Numbers_n_in_which_number_1_occur_twice
use warnings;

my @twoones = grep tr/1// =~ 2, 1 .. 1000;
print "@twoones\n" =~ s/.{60}\K /\n/gr;
