#!/usr/bin/perl
use v5.20;
use experimental qw(signatures);

use List::Util qw( sum ) ;

sub sum_3_5($limit) {
   return sum grep { $_ % 3 == 0 || $_ % 5 == 0 } ( 1..$limit - 1 ) ;
}

say "The sum is ${\(sum_3_5 1000)}!\n" ;
