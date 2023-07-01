#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Minimal_steps_down_to_1
use warnings;
no warnings 'recursion';
use List::Util qw( first );
use Data::Dump 'dd';

for ( [ 2000, [2, 3], [1] ], [ 2000, [2, 3], [2] ] )
  {
  my ( $n, $div, $sub ) = @$_;
  print "\n", '-' x 40, " divisors @$div subtractors @$sub\n";
  my ($solve, $max) = minimal( @$_ );
  printf "%4d takes %s step(s): %s\n",
    $_, $solve->[$_] =~ tr/ // - 1, $solve->[$_] for 1 .. 10;
  print "\n";
  printf "%d number(s) below %d that take $#$max steps: %s\n",
    $max->[-1] =~ tr/ //, $n, $max->[-1];
  ($solve, $max) = minimal( 20000, $div, $sub );
  printf "%d number(s) below %d that take $#$max steps: %s\n",
    $max->[-1] =~ tr/ //, 20000, $max->[-1];
  }

sub minimal
  {
  my ($top, $div, $sub) = @_;
  my @solve = (0, ' ');
  my @maximal;
  for my $n ( 2 .. $top )
    {
    my @pick;
    for my $d ( @$div )
      {
      $n % $d and next;
      my $ans = "/$d $solve[$n / $d]";
      $pick[$ans =~ tr/ //] //= $ans;
      }
    for my $s ( @$sub )
      {
      $n > $s or next;
      my $ans = "-$s $solve[$n - $s]";
      $pick[$ans =~ tr/ //] //= $ans;
      }
    $solve[$n] = first { defined  } @pick;
    $maximal[$solve[$n] =~ tr/ // - 1] .= " $n";
    }
  return \@solve, \@maximal;
  }
