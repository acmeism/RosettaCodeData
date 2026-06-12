#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Sort_primes_from_list_to_a_list
use warnings;
use ntheory qw( is_prime );
use List::AllUtils qw( nsort_by );

print "@{[ nsort_by {$_} grep is_prime($_), 2,43,81,122,63,13,7,95,103 ]}\n";
