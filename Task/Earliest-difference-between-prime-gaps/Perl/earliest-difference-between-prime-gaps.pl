#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Earliest_difference_between_prime_gaps
use warnings;
use ntheory qw( primes );

my @gaps;
my $primeref = primes( 1e9 );
for my $i ( 2 .. $#$primeref )
  {
  my $diff = $primeref->[$i] - $primeref->[$i - 1];
  $gaps[ $diff >> 1 ] //= $primeref->[$i - 1];
  }
my %first;
for my $i ( 1 .. $#gaps )
  {
  defined $gaps[$i] && defined $gaps[$i-1] or next;
  my $diff = abs $gaps[$i] - $gaps[$i-1];
  for my $m ( map 10 ** $_, 1 .. 10 )
    {
    $diff > $m and !$first{$m}++ and
      print "above $m gap @{[$i * 2 - 2 ]} abs( $gaps[$i-1] - $gaps[$i] )\n";
    }
  }
