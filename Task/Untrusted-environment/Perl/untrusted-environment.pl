#!/usr/bin/perl -T
my $f = $ARGV[0];
open FILE, ">$f" or die 'Cannot open file for writing';
print FILE "Modifying an arbitrary file\n";
close FILE;
