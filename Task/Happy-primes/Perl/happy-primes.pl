#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Happy_primes
use warnings;
use List::AllUtils qw( sum );
use ntheory qw( primes is_prime );

sub is_happy
  {
  my ($n, %seen) = shift;
  $n = sum map $_**2, split //, $n while $n > 1 and $seen{$n}++ == 0;
  return $n == 1;
  }

print "First 50 happy primes:\n",
  join( '', map { sprintf "%5d", $_ } grep is_happy($_), primes(1664)->@*) =~
  s/.{50}\K/\n/gr;

my $happyprime = 0;
my $happy = 1;
my $denom = 2;
my $fraction = 1 / $denom;
my $n = 7;
print "\n                 Index  Value\n";
while( $denom <= 8 )
  {
  is_happy($n) and $happy++, is_prime($n) && $happyprime++;
  if( $happyprime / $happy <= $fraction )
    {
    printf "fraction 1/%-2d: %7d  %5d\n", $denom, $happy, $n;
    $fraction = 1 / ++$denom;
    }
  $n++;
  }
