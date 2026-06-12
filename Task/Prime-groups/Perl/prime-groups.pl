#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Prime_groups#
use warnings;
use ntheory qw( is_prime );

my @try = ('riOtjuoq', 'wjtiOxtj', 'akwercjoeiJ', 'Weej', 'Aek', 'jjgja');

for ( @try )
  {
  print /(.).*?(.).*?(.)(??{
    is_prime(abs(ord($1)-ord($2))) &&
    is_prime(abs(ord($1)-ord($3))) &&
    is_prime(abs(ord($2)-ord($3))) ? '' : '(*FAIL)'
    })/ ? "$1$2$3\n" : "Not found.\n";
  }

print "\n";

for ( @try )
  {
  print /(.).*?(.)(??{
    is_prime(abs(ord($1)-ord($2))) ? '' : '(*FAIL)'
    })/ ? "$1$2\n" : "Not found.\n";
  }
