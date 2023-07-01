#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Motzkin_numbers
use warnings;
use ntheory qw( is_prime );

sub motzkin
  {
  my $N = shift;
  my @m = ( 0, 1, 1 );
  for my $i ( 3 .. $N )
    {
    $m[$i] = ($m[$i - 1] * (2 * $i - 1) + $m[$i - 2] * (3 * $i - 6)) / ($i + 1);
    }
  return splice @m, 1;
  }

print "  n          M[n]\n";
my $count = 0;
for ( motzkin(42) )
  {
  printf "%3d%25s  %s\n", $count++, s/\B(?=(\d\d\d)+$)/,/gr,
    is_prime($_) ? 'prime' : '';
  }
