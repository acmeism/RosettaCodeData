#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Find_words_which_contains_most_consonants
use warnings;

my @most;
@ARGV = 'unixdict.txt';
length > 11 and !/([^aeiou]).*\1/ and $most[ tr/aeiou\n//c ] .= $_ while <>;
$most[$_] and printf "%d Unique consonants, word count: %d\n\n%s\n\n",
  $_, $most[ $_ ] =~ tr/\n//, $most[ $_ ] =~ tr/\n/ /r =~ s/.{66}\K /\n/gr
  for reverse 0 .. $#most;
