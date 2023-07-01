#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Longest_Common_Substring
use warnings;

my $one = 'thisisatest';
my $two = 'testing123testing';

my @best;
"$one\n$two" =~ /(.+).*\n.*\1(?{ $best[length $1]{$1}++})(*FAIL)/;
print "$_\n" for sort keys %{ $best[-1] };
