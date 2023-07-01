#!/usr/bin/perl
use strict ;
use warnings ;
use POSIX qw( log10 ) ;

my @fibonacci = ( 0 , 1  ) ;
while ( @fibonacci != 1000 ) {
   push @fibonacci , $fibonacci[ -1 ] + $fibonacci[ -2 ] ;
}
my @actuals ;
my @expected ;
for my $i( 1..9 ) {
   my $sum = 0 ;
   map { $sum++ if $_ =~ /\A$i/ } @fibonacci ;
   push @actuals , $sum / 1000  ;
   push @expected , log10( 1 + 1/$i ) ;
}
print "         Observed         Expected\n" ;
for my $i( 1..9 ) {
   print "$i : " ;
   my $result = sprintf ( "%.2f" , 100 * $actuals[ $i - 1 ] ) ;
   printf "%11s %%" , $result ;
   $result = sprintf ( "%.2f" , 100 * $expected[ $i - 1 ] ) ;
   printf "%15s %%\n" , $result ;
}
