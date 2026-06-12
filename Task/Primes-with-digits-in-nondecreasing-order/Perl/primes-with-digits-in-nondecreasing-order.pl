#!/usr/bin/perl

use strict;
use warnings;
use ntheory qw( primes );

my @want = grep ! /(.)(.)(??{$1 > $2 ? '' : '(*FAIL)'})/, @{ primes(1000) };
print "@want" =~ s/.{50}\K /\n/gr . "\n\ncount: " . @want . "\n";
