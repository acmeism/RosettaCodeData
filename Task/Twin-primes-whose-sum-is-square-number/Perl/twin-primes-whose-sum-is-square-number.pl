#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Twin_primes_whose_sum_is_square_number#
use warnings;
use ntheory qw( twin_primes is_square );

my $n = my @tp = grep is_square($_ + $_ + 2), @{ twin_primes(1e7) };
print "$n were found\n\n", map "$_\n", (sprintf '%8d' x $n, @tp) =~ /.{1,80}/g;
