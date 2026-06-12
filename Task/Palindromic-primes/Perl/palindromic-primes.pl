#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Palindromic_primes
use warnings;

$_ == reverse and (1 x $_ ) !~ /^(11+)\1+$/ and print "$_ " for 2 .. 1e3;
