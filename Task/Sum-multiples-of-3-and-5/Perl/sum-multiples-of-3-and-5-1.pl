#!/usr/bin/perl
use strict ;
use warnings ;
use List::Util qw( sum ) ;

sub sum_3_5 {
   my $limit = shift ;
   return sum grep { $_ % 3 == 0 || $_ % 5 == 0 } ( 1..$limit - 1 ) ;
}

print "The sum is " . sum_3_5( 1000 ) . " !\n" ;
