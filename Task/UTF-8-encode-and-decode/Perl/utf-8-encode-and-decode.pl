#!/usr/bin/perl
use strict;
use warnings;
use Unicode::UCD 'charinfo';         # getting the unicode name of the character
use utf8;                            # using non-ascii-characters in source code
binmode STDOUT, ":encoding(UTF-8)";  # printing non-ascii-characters to screen

my @chars = map {ord} qw/A ö Ж € 𝄞/; # @chars contains the unicode points
my $print_format = '%5s  %-35s';
printf "$print_format %8s  %s\n" , 'char', 'name', 'unicode', 'utf-8 encoding';
map{
	my $name = charinfo($_)->{'name'}; # get unicode name
	printf "$print_format  %06x  " , chr, lc $name, $_;
	my $utf8 = chr;                    # single char (using implicit $_)
	utf8::encode($utf8);               # inplace encoding into utf8 parts
	map{                               # for each utf8 char print ord
		printf " %x", ord;
	} split //, $utf8;
	print "\n";
} @chars;
