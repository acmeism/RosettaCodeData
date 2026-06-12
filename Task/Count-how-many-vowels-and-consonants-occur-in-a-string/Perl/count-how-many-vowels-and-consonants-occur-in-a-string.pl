#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Count_how_many_vowels_and_consonants_occur_in_a_string
use warnings;

while( <DATA> )
  {
  print "@{[ $- = tr/aeiouAEIOU// ]} vowels @{[ tr/a-zA-Z// - $-
    ]} consonants in: $_\n"
  }

__DATA__
test one
TEST ONE
Now is the time for all good men to come to the aid of their country.
Forever Perl Programming Language
