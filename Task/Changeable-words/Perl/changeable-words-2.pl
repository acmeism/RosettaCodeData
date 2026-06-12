#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Changeable_words
use warnings;

local $_ = do {local(@ARGV, $/) = 'unixdict.txt'; <> =~ s/^.{0,11}\n//gmr };
my $count = 0;
printf "%3d:  %15s  <->  %s\n", ++$count, $1, $4
  while /^ ((\N*)\N(\N*)) \n(?=.*^ (\2\N\3) \n)/gmsx;
