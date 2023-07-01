#!/usr/bin/perl

use strict; # https://en.wikipedia.org/wiki/Euler%27s_constant
use warnings;
use List::Util qw( sum );

print sum( map 1 / $_, 1 .. 1e6) - log 1e6, "\n";
