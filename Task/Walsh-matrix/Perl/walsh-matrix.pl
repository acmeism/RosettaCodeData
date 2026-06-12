#!/usr/bin/perl

use strict; # https://www.rosettacode.org/wiki/Walsh_matrix
use warnings;
use List::AllUtils qw( bundle_by pairwise nsort_by );

sub Kronecker
  {
  my ($ac, $bc) = map scalar($_->[0]->@*), my ($A, $B) = @_;
  return [ bundle_by { [ @_ ] } $ac * $bc, pairwise { $a * $b }
    @{[ map { map { ($_) x $bc } (@$_) x @$B } @$A ]}, # left side
    @{[ ( map { (@$_) x $ac } @$B ) x @$A ]} ];        # right side
  }

sub Walsh # Task - write a routine that, given k, returns Walsh of 2**k
  {
  my $k = shift;
  $k > 0 ? Kronecker [ [1,1],[1,-1] ], Walsh( $k - 1 ) : [[1]];
  }

for my $k ( 1, 3, 2, 4 ) # test code out of order just for fun
  {
  printf '%3d'x@$_ . "\n", @$_ for [], (my $w = Walsh($k))->@*, [];
  print nsort_by { scalar(() = /(.)\1*/g) }
    map { join '', (0, '_', '#')[@$_], "\n" } $w->@*;
  }
