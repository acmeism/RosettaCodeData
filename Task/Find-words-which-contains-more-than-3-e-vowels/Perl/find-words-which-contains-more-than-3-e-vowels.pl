#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Find_words_which_contains_more_than_3_e_vowels
use warnings;

@ARGV = 'unixdict.txt';
tr/e// > 3 and tr/aiou// == 0 and print while <>;
