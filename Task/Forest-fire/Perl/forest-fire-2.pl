#!/usr/bin/perl

use strict;                       # http://www.rosettacode.org/wiki/Forest_fire
use warnings;

my $p = 0.01;                               # probability of empty -> tree
my $f = 0.0001;                             # probability of  tree -> burning

my ($high, $wide) = split ' ', qx(stty size);      # 135 174 tiny font in xterm
my $mask = 0 x $wide . (0 . 7 x ($wide - 2) . 0) x ($high - 5) . 0 x $wide;
my $forest = $mask =~ s/7/ rand() < 0.5 ? 2 : 1 /ger;

for( 1 .. 1e3 )
  {                                         # 0=border 1=empty 2=tree 3=burning
  print "\e[H", $forest =~ tr/0123/  ^#/r, "\n"; # ^=tree  #=burning tree
  my $n = $forest =~ tr/123/004/r;          # 4=a neighbor is burning
  $forest |= 0 x $_ . $n | substr $n, $_ for 1, $wide - 1 .. $wide + 1;
  $forest &= $mask;                         # clear borders and trim
  $forest =~ tr/1-7/et10e31/;               # step to next generation
  $forest =~ s/t/ rand() < $f ? 3 : 2 /ge;  # rule 3) tree cell to burning
  $forest =~ s/e/ rand() < $p ? 2 : 1 /ge;  # rule 4) empty cell to tree
  select undef, undef, undef, 0.1;          # comment out for full speed
  }
