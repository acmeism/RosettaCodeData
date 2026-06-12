#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Solve_hanging_lantern_problem
use warnings;

$_ = 'a bc def';

my $answer = '';
find($_, '');
print "count = @{[ $answer =~ tr/\n// ]}\n", $answer;

sub find
  {
  my ($in, $found) = @_;
  find( $` . $', $found . $& ) while $in =~ /\w\b/g;
  $in =~ /\w/ or $answer .= '[' . $found =~ s/\B/,/gr . "]\n";
  }
