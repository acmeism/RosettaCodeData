#!/usr/bin/perl

use strict;
use warnings;

my $pat = join '', grep +(1 x ord) !~ /^(11+)\1+$/, 'a'..'z', 'A'..'Z';
@ARGV = 'unixdict.txt';
print join('', grep /^[$pat]+$/, <>) =~ tr/\n/ /r =~ s/.{1,71}\K /\n/gr;
