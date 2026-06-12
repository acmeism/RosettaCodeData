#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/One-two_primes
use warnings;
use ntheory qw( is_prime );

for my $n ( 1 .. 20, map 100 * $_, 1 .. 20 )
  {
  local $_ = 1 x $n;
  s/12*$/ $& =~ tr-12-21-r /e or $_ = 0 until $_ < 1 or is_prime( $_ ) ;
  s/^1{21,}/ sprintf "(1 x %d) ", length $& /e;
  printf "%5d:  %s\n", $n, $_;
  }
