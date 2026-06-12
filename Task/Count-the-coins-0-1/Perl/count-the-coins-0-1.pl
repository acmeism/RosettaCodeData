#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Count_the_coins/0-1
use warnings;

countcoins( 6, [1, 2, 3, 4, 5] );
countcoins( 6, [1, 1, 2, 3, 3, 4, 5] );
countcoins( 40, [1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100] );

my $count;

sub countcoins
  {
  my ($want, $coins) = @_;
  print "\nsum $want coins @$coins\n";
  $count = 0;
  count($want, [], 0, $coins);
  print "Number of ways: $count\n";
  }

sub count
  {
  my ($want, $used, $sum, $have) = @_;
  if( $sum == $want ) { $count++ }
  elsif( $sum > $want or @$have == 0 ) {}
  else
    {
    my ($thiscoin, @rest) = @$have;
    count( $want, [@$used, $thiscoin], $sum + $thiscoin, \@rest);
    count( $want, $used, $sum, \@rest);
    }
  }
