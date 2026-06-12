#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Safe_and_Sophie_Germain_primes
use warnings;
use ntheory qw( forprimes is_prime);

my @want;
forprimes { is_prime(2 * $_ + 1) and (50 == push @want, $_)
  and print("@want\n" =~ s/.{65}\K /\n/gr) + exit } 2, 1e9;
