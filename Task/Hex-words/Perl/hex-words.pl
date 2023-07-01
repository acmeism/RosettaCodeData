#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Hex_words
use warnings;
use List::AllUtils qw( nsort_by uniq );

sub root
  {
  local $_ = shift;
  $_ = eval while s/\B/+/g;
  return $_;
  }

my @bydecimal = grep +(uniq /[a-f]/g)[3],
  my @byroot = map { sprintf "%10s %10d %3d\n", $_, hex $_, root hex $_
  } do { local(@ARGV, $/) = 'unixdict.txt'; <> =~ /^[a-f]{4,}$/gm };

print +(nsort_by { (split ' ')[2] } @byroot),
  "total count = @{[ scalar @byroot ]} and @{[ scalar @bydecimal
  ]} have at least 4 distinct digits\n",
  reverse nsort_by { (split ' ')[1] } @bydecimal;
