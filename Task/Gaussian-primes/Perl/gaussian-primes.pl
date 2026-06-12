#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Gaussian_primes
use warnings;
use ntheory qw( is_prime );

my ($plot, @primes) = gaussianprimes(10);
print "Primes within 10\n", join(',  ', @primes) =~ s/.{94}\K  /\n/gr;
($plot, @primes) = gaussianprimes(50);
print "\n\nPlot within 50\n$plot";

sub gaussianprimes
  {
  my $size = shift;
  my $plot = ( ' ' x (2 * $size + 1) . "\n" ) x (2 * $size + 1);
  my @primes;
  for my $A ( -$size .. $size )
    {
    my $limit = int sqrt $size**2 - $A**2;
    for my $B ( -$limit .. $limit )
      {
      my $norm = $A**2 + $B**2;
      if ( is_prime( $norm )
      or ( $A==0 && is_prime(abs $B) && (abs($B)-3)%4 == 0)
      or ( $B==0 && is_prime(abs $A) && (abs($A)-3)%4 == 0) )
        {
          push @primes, sprintf("%2d%2di", $A, $B) =~ s/ (\di)/+$1/r;
          substr $plot, ($B + $size + 1) * (2 * $size + 2) + $A + $size + 1, 1, 'X';
        }
      }
    }
  return $plot, @primes;
  }
