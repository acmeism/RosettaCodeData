#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Giuga_numbers
use warnings;
use ntheory qw( factor forcomposites );
use List::Util qw( all );

forcomposites
  {
  my $n = $_;
  all { ($n / $_ - 1) % $_ == 0 } factor $n and print "$n\n";
  } 4, 67000;
