# 20220301 Perl programming solution

use strict;
use warnings;

use Algorithm::Line::Bresenham 'circle';

my @points;
my @circle = circle((10) x 3);

for (@circle) { $points[$_->[0]][$_->[1]] = '#' }

print join "\n", map { join '', map { $_ || ' ' } @$_ } @points
