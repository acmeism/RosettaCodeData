#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/Bernoulli%27s_triangle
use warnings;
use List::MoreUtils qw( slide );

print my @t = 1;
print join ' ', @t = ((slide {$a+$b} 0, @t), 2**$_) for 1 .. 14;
