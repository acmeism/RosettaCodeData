#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Change_e_letters_to_i_in_words
use warnings;
no warnings 'uninitialized';

my $file = do { local (@ARGV, $/) = 'unixdict.txt'; <> };
my %i = map { tr/e/i/r => sprintf "%30s  %s\n", $_, tr/e/i/r }
  $file =~ /^(?=.{6}).*e.*$/gm;
print @i{ split ' ', $file };
