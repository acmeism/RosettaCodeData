#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Jewels_and_Stones#Perl
use warnings;

sub count_jewels { scalar( () =  $_[0] =~ /[ $_[1] ]/gx ) } # stones, jewels

print "$_ = ", count_jewels( split ), "\n" for split /\n/, <<END;
aAAbbbb aA
aAAbbbb abc
ZZ z
END
