#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Specific_characters
use warnings;
use List::AllUtils qw( uniq );

my @list = ("ahwiueshaiu","ajxxfioaaf","ajrdsfroiwr");

my $want = join '', grep "@list" =~ /^[^$_]*$_[^$_ ]*$_[^$_]*$/,
  map { split // } @list;
my @specific = map { scalar grep $want =~ $_, uniq split // } @list;
my @non      = map { scalar grep $want !~ $_, uniq split // } @list;

print "    specific characters  @specific\n";
print "non specific characters  @non\n";
