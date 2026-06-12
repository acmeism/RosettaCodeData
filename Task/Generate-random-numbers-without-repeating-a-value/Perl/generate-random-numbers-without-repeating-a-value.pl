#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Generate_random_numbers_without_repeating_a_value
use warnings;
use List::Util qw( shuffle );

print "@{[ shuffle 1 .. 20 ]}\n" for 1 .. 5;
