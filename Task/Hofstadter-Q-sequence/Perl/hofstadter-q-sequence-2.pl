#!/usr/bin/perl
use warnings;
use strict;

my @hofstadters = ( 1 , 1 );
while ( @hofstadters < 100000 ) {
   my $nextn = @hofstadters + 1;
# array index counting starts at 0 , so we have to subtract 1 from the numbers!
   push @hofstadters ,  $hofstadters [ $nextn - 1 - $hofstadters[ $nextn - 1 - 1 ] ]
      + $hofstadters[ $nextn - 1 - $hofstadters[ $nextn - 2 - 1 ]];
}
for my $i ( 0..9 ) {
   print "$hofstadters[ $i ]\n";
}
print "The 1000'th term is $hofstadters[ 999 ]!\n";
my $less_than_preceding = 0;
for my $i ( 0..99998 ) {
   $less_than_preceding++ if $hofstadters[ $i + 1 ] < $hofstadters[ $i ];
}
print "Up to and including the 100000'th term, $less_than_preceding terms are less " .
   "than their preceding terms!\n";
