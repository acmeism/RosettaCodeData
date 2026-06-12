#!/usr/bin/perl

use strict;
use warnings;

my $words = do { local (@ARGV, $/) = 'unixdict.txt'; <> };
my %words = map { $_, 1 } $words =~ /^.{3,}$/gm;
for ( $words =~ /^.{6,}$/gm )
  {
  my $even = s/(.).?/$1/gr;
  my $odd = s/.(.?)/$1/gr;
  $words{$even} && $words{$odd} and print "$_ => [ $even $odd ]\n";
  }
