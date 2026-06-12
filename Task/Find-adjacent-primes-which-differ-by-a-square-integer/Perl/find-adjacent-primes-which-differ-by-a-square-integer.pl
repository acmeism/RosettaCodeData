#!/usr/bin/perl

use strict;    # https://rosettacode.org/wiki/Find_adjacents_primes_which_difference_is_square_integer
use warnings;
use ntheory qw( primes is_square );

my $primeref = primes(1e6);
for my $i (1 .. $#$primeref) {
    (my $diff = $primeref->[$i] - $primeref->[$i - 1]) > 36 or next;
    is_square($diff) and print "$primeref->[$i] - $primeref->[$i - 1] = $diff\n";
}
