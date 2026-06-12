#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Primes_whose_first_and_last_number_is_3
use warnings;
use ntheory qw( primes );

my @n33 = grep /^3/ && /3$/, @{ primes( 4000 ) };
my $n33 = grep /^3/ && /3$/, @{ primes( 1_000_000 ) };
print @n33 . " under 4000\n\n@n33" =~ s/.{75}\K /\n/gr,
  "\n\n$n33 under 1000000\n";
