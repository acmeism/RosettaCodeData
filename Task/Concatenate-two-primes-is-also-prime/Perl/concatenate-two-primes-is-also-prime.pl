#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Concatenate_two_primes_is_also_prime
use warnings;
use ntheory qw( primes is_prime );
use List::Util qw( uniq );

my @primes = @{ primes(100) };
my @valid = uniq sort { $a <=> $b } grep is_prime($_),
  map { my $prefix = $_; map "$prefix$_", @primes } @primes;
print @valid . " primes found\n\n@valid\n" =~ s/.{79}\K /\n/gr;
