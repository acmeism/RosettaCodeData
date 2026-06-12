#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Convert_day_count_to_ordinal_date
use warnings;

my $offset = 1971*365 + 113;

for ( 0, 109573, 146096 )
  {
  print "\nDay count: $_\n";
  for my $n ( map $_ * 146097, 0 .. 5 )
    {
    my @d = gmtime 60*60*24 * ( $_ - $offset + $n );
    printf "%02d/%02d/%04d\n", $d[3], $d[4]+1, $d[5]+1900;
    }
  }
