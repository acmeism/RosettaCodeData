#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Prime_numbers_whose_neighboring_pairs_are_tetraprimes
use warnings;
use ntheory qw( factor primes );
use List::AllUtils qw( reduce uniq );
$SIG{__WARN__} = sub { die @_ };

sub tetraprime
  {
  my @uniq = uniq( my @factors = factor( shift ));
  return @factors == 4 && @uniq == 4, grep $_ == 7, @factors;
  }

sub before
  {
  my ($tetra1, $seven1) = tetraprime( $_[0] - 1 );
  my ($tetra2, $seven2) = tetraprime( $_[0] - 2 );
  return $tetra1 && $tetra2, $seven1 || $seven2;
  }

sub after
  {
  my ($tetra1, $seven1) = tetraprime( $_[0] + 1 );
  my ($tetra2, $seven2) = tetraprime( $_[0] + 2 );
  return $tetra1 && $tetra2, $seven1 || $seven2;
  }

sub gaps
  {
  my @gap;
  reduce { push @gap, abs $b - $a; $b } @_;
  sort { $a <=> $b } @gap;
  }

sub median
  {
  @_ % 2 ? $_[@_ >> 1] : $_[@_ >> 1] + $_[@_ - 2 >> 1] >> 1;
  }

for my $limit ( 1e5, 1e6 )
  {
  my @primes = @{ primes( 3, $limit ) };
  for my $dir ( qw( preceding following ) )
    {
    my $side = $dir eq  'preceding' ? \&before : \&after;
    my @tetra;
    my $sevens = 0;
    for ( @primes )
      {
      my ($tetra, $seven) = $side->($_);
      $tetra and push @tetra, $_;
      $tetra && $seven and $sevens++;
      }
    my $total = @tetra;
    my $range = @tetra > 99 ? '' : ":\n@tetra" =~ s/.{75}\K /\n/gr;
    my @gaps = gaps @tetra;
    my( $mingap, $medgap, $maxgap) = ($gaps[0], median(@gaps), $gaps[-1]);
    s/\B(?=(...)+$)/,/g for $maxgap, $medgap, $maxgap, my $comma = $limit;
    print <<END;
Found $total primes under $comma whose $dir neighboring pair are tetraprimes$range
of which $sevens have a neighboring pair one of whose factors is 7.

Minimum gap between those $total primes : $mingap
Median  gap between those $total primes : $medgap
Maximum gap between those $total primes : $maxgap

END
    }
  }
