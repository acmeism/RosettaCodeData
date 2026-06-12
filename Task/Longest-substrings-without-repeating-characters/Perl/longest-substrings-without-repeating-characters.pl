#!/usr/bin/perl

use strict; # Longest_substrings_without_repeating_characters
use warnings;

for my $string ( qw( xyzyabcybdfd xyzyab zzzzz a thisisastringtest ) )
  {
  local $_ = $string;
  my @sub;
  length $+ >= $#sub and ++$sub[length $+]{$+} while s/.*(.)(.*\K\1.*)|(.+)//s;
  printf "%20s -> %s\n", $string, join ' ', sort keys %{ pop @sub };
  }
