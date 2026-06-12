#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Smallest_multiple#Raku
use warnings;
use ntheory qw( lcm );

print "for $_, it's @{[ lcm(1 .. $_) ]}\n" for 10, 20;
