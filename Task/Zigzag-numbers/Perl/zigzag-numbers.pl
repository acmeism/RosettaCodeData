#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Zigzag_numbers
use warnings;
use List::AllUtils qw( extract_first_by );

sub updown
  {
  my ($dir, $have, $rest) = @_;
  @$rest or return print " (@$have)";
  my $last = $have->[-1] // $rest->[-1] + 1;
  for my $n ( grep $dir ? $_ > $last : $_ < $last, @$rest )
    {
    my @new = @$rest;
    updown( $dir ^ 1, [ @$have, extract_first_by {$_ == $n} @new ], \@new );
    }
  }

for my $N ( 1 .. 5 )
  {
  print "Permutations for N = $N:";
  updown( 0, [], [1 .. $N] );
  print "\n\n";
  }

use bigint;
my %cache;
sub E
  {
  my ($n, $k) = @_;
  return $cache{"@_"} //= $k ? E($n, $k - 1) + E($n - 1, $n - $k) : $n ? 0 : 1;
  }
print " M  zigzag number\n--  -------------\n";
printf "%2d  %s\n", $_, E($_, $_) for 1 .. 30;
