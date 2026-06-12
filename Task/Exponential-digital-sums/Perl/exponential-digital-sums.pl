#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Exponential_digital_sums
use warnings;
use bigint;
use ntheory qw( sumdigits );
$SIG{__WARN__} = sub { die @_ };

my $count = 0;
my $n = 2;
while( $count < 20 )
  {
  for my $e ( 2 .. 10 )
    {
    if( $n == sumdigits( $n ** $e ) )
      {
      printf "%3d: %d^%d\n", ++$count, $n, $e;
      last;
      }
    }
  $n++;
  }

print "\n";

$count = 0;
$n = 2;
while( $count < 10 )
  {
  my @ways = ();
  for my $e ( 2 .. 60 )
    {
    $n == sumdigits( $n ** $e ) and push @ways, "$n^$e";
    }
  @ways >= 3 and printf "%3d: %s\n", ++$count, join ', ', @ways;
  $n++;
  }
