#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Unique_characters_in_each_string
use warnings;

my @strings = ("1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz");
my $chars = join "\n", @strings;
print "@{[ sort grep
  $chars !~ /$_.*$_/ &&           # the 'only once in each string' test
  @strings == $chars =~ s/$_//g,  # the 'in every string' test
  $chars =~ /./g ]}\n";
