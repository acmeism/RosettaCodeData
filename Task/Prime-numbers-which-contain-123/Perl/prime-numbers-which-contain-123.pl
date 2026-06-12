#!/usr/bin/perl

use strict;
use warnings;
use ntheory qw( primes );

my @hundredthousand = grep /123/, @{ primes(1e5) };
my $million = grep /123/, @{ primes(1e6) };
print "@hundredthousand\n\nmillion count is $million\n" =~ s/.{70}\K /\n/gr;
