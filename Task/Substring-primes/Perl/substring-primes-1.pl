#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Substring_primes
use warnings;

my %prime;

LOOP:
for (2 .. 500 )
  {
  my %substrings =  ();
  /.+(?{ $prime{$&} or $substrings{$&}++ })(*FAIL)/;
  for my $try ( sort { $a <=> $b } keys %substrings )
    {
    $try < 2 and next LOOP;
    $prime{$try} || (1 x $try) !~ /^(11+)\1+$/ ? $prime{$try}++ : next LOOP;
    }
  }
printf "  %d" x %prime . "\n", sort {$a <=> $b} keys %prime;
