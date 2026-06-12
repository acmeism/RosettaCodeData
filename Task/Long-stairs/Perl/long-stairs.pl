#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Long_stairs
use warnings;

my $sumseconds = my $sumsizes = my $runs = 0;
for ( 1 .. 1e4 )
  {
  $runs++;
  my $behind = 0;
  my $ahead =  100;
  my $seconds = 0;
  while( $ahead  > 0 )
    {
    rand() <= ($ahead / ($behind + $ahead)) ? $ahead++ : $behind++ for 1 .. 5;
    $behind++; # one step up
    $ahead--;
    $seconds++;
    $_ == 1 and 600 <= $seconds <= 609 and
      print "step $seconds: $behind behind, $ahead ahead\n";
    }
  $sumsizes += $behind;
  $sumseconds += $seconds;
  }
printf "\naverage stair length %d average seconds %d\n",
  $sumsizes / $runs, $sumseconds / $runs;
