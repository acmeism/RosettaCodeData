#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/List_division
use warnings;

sub listdivision
  {
  my ($n, $list) = @_;
  my @list = @$list;
  $n > @list and die "n of $n larger than the list";
  return map [ splice @list, 0, @list / $_ ], reverse 1 .. $n;
  }

for my $n ( 2, 5, 9 )
  {
  for my $length ( 25, 26 )
    {
    use Data::Dump 'dd'; dd { n => $n, length => $length,
      output => [ listdivision($n, [ (reverse 'a'..'z')[0 .. $length - 1] ] ) ] };
    }
  }
