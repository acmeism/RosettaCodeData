#!/usr/bin/perl
use strict ;
use warnings ;

my $current = 0 ;
while ( ($current ** 2 ) % 1000000  != 269696 ) {
   $current++ ;
}
print "The square of $current is " . ($current * $current) . " !\n" ;
