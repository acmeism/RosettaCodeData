#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Juggler_sequence
use warnings;
use Math::BigInt lib => 'GMP';

print "       n  l(n) i(n)  h(n) or d(n)\n";
print " -------  ---- ----  ------------\n";
for my $i ( 20 .. 39,
  113, 173, 193, 2183, 11229, 15065, 15845, 30817,
  48443, 275485, 1267909, 2264915, 5812827,
  7110201  # tried my luck, luck takes about 94 seconds
  )
  {
  my $max = my $n = Math::BigInt->new($i);
  my $at = my $count = 0;
  while( $n > 1 )
    {
    $n = sqrt( $n & 1 ? $n ** 3 : $n );
    $count++;
    $n > $max and ($max, $at) = ($n, $count);
    }

  if( length $max < 27 )
    {
    printf "%8d  %4d  %3d  %s\n", $i, $count, $at, $max;
    }
  else
    {
    printf "%8d  %4d  %3d  d(n) = %d digits\n", $i, $count, $at, length $max;
    }
  }
