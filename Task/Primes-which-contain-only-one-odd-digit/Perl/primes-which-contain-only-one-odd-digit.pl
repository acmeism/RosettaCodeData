#!/usr/bin/perl

use strict;
use warnings;
use ntheory qw( primes );

my @singleodd = grep tr/13579// == 1, @{ primes(1e3) };
my $million = grep tr/13579// == 1, @{ primes(1e6) };
print "found " . @singleodd .
  "\n\n@singleodd\n\nfound $million in 1000000\n" =~ s/.{60}\K /\n/gr;
