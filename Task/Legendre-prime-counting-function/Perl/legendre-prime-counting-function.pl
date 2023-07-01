#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Legendre_prime_counting_function
use warnings;
no warnings qw(recursion);
use ntheory qw( nth_prime prime_count );

my (%cachephi, %cachepi);

sub phi
  {
  return $cachephi{"@_"} //= do {
    my ($x, $aa) = @_;
    $aa <= 0 ? $x : phi($x, $aa - 1) - phi(int $x / nth_prime($aa), $aa - 1) };
  }

sub pi
  {
  return $cachepi{$_[0]} //= do {
    my $n = shift;
    $n < 2 ? 0 : do{ my $aa = pi(int sqrt $n); phi($n, $aa) + $aa - 1 } };
  }

print "e             n   Legendre    ntheory\n",
      "-             -   --------    -------\n";
for (1 .. 9)
  {
  printf "%d  %12d %10d %10d\n", $_, 10**$_, pi(10**$_), prime_count(10**$_);
  }
