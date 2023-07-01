#!/usr/bin/perl
use strict;
use warnings;
use Term::ReadKey;
ReadMode 4;
my $key;
until(defined($key = ReadKey(-1))){
	# anything
	sleep 1;
}
print "got key '$key'\n";
ReadMode('restore');
