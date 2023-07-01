#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Rare_numbers
use warnings;
use integer;

my $count = 0;
my @squares;
for my $large ( 0 .. 1e5 )
  {
  my $largesquared = $squares[$large] = $large * $large; # $large ** 2;
  for my $small ( 0 .. $large - 1 )
    {
    my $n = $largesquared + $squares[$small];
    2 * $large * $small == reverse $n or next;
    printf "%12s %s\n", $n, scalar reverse $n;
    $n == reverse $n and die "oops!"; # palindrome check
    ++$count >= 5 and exit;
    }
  }
