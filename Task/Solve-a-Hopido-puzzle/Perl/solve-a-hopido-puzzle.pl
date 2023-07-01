#!/usr/bin/perl

use strict;             # http://www.rosettacode.org/wiki/Solve_a_Hopido_puzzle
use warnings;

$_ = do { local $/; <DATA> };
s/./$&$&/g;             # double chars
my $w = /\n/ && $-[0];
my $wd = 3 * $w + 1;    # vertical gap
my $wr = 2 * $w + 8;    # down right gap
my $wl = 2 * $w - 8;    # down left gap
place($_, '00');
die "No solution\n";

sub place
  {
  (local $_, my $last) = @_;
  (my $new = $last)++;
  /$last.{10}(?=00)/g   and place( s/\G00/$new/r, $new ); # right
  /(?=00.{10}$last)/g   and place( s/\G00/$new/r, $new ); # left
  /$last.{$wd}(?=00)/gs and place( s/\G00/$new/r, $new ); # down
  /(?=00.{$wd}$last)/gs and place( s/\G00/$new/r, $new ); # up
  /$last.{$wr}(?=00)/gs and place( s/\G00/$new/r, $new ); # down right
  /(?=00.{$wr}$last)/gs and place( s/\G00/$new/r, $new ); # up left
  /$last.{$wl}(?=00)/gs and place( s/\G00/$new/r, $new ); # down left
  /(?=00.{$wl}$last)/gs and place( s/\G00/$new/r, $new ); # up right
  /00/ and return;
  print "Solution\n\n", s/  / /gr =~ s/0\B/ /gr;
  exit;
  }

__DATA__
. 0 0 . 0 0 .
0 0 0 0 0 0 0
0 0 0 0 0 0 0
. 0 0 0 0 0 .
. . 0 0 0 . .
. . . 0 . . .
