#!/usr/bin/perl

use strict;
use warnings;

my %sets = (
  A => [],
  B => [1, 2, 3, 4, 5],
  C => [1, 3, 5, 7, 9],
  D => [2, 4, 6, 8, 10],
  E => [2, 3, 5, 7],
  F => [8],
  );
use Data::Dump 'dd'; dd \%sets;

for my $left (sort keys %sets )
  {
  for my $right (sort keys %sets )
    {
    my %union;
    $union{ $_ }++ for @{ $sets{$left} }, @{ $sets{$right} };
    print "J($left,$right) = ",
      %union ? (grep $_ == 2, values %union) / (keys %union) : 1, "\n";
    }
  }
