#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Pascal%27s_triangle

regexpascal($_), print "\n" for 7, 16, 0, -1;

sub regexpascal
  {
  local $_ = "1\n";
  print, s/^/0 /, s/(\d+)(?= (\d+))/$1 + $2/ge for ($_) x shift;
  }
