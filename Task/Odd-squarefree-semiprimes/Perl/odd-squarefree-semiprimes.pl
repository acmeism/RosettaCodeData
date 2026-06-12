#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Odd_squarefree_semiprimes
use warnings;

my (@primes, @found) = grep $_ & 1 && (1 x $_) !~ /^(11+)\1+$/, 3 .. 999 / 3;
"@primes" =~ /\b(\d+)\b.*?\b(\d+)\b(?{ $found[$1 * $2] = $1 * $2 })(*FAIL)/;
print "@{[ grep $_, @found[3 .. 999] ]}\n" =~ s/.{75}\K /\n/gr;
