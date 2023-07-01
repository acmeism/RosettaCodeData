#!/usr/bin/perl
use strict ;
use warnings ;
use feature 'say' ;

sub log2 {
   my $number = shift ;
   return log( $number ) / log( 2 ) ;
}

open my $fh , "<" , $ARGV[ 0 ] or die "Can't open $ARGV[ 0 ]$!\n" ;
my %frequencies ;
my $totallength = 0 ;
while ( my $line = <$fh> ) {
   chomp $line ;
   next if $line =~ /^$/ ;
   map { $frequencies{ $_ }++ } split( // , $line ) ;
   $totallength += length ( $line ) ;
}
close $fh ;
my $infocontent = 0 ;
for my $letter ( keys %frequencies ) {
   my $content = $frequencies{ $letter } / $totallength ;
   $infocontent += $content * log2( $content ) ;
}
$infocontent *= -1 ;
say "The information content of the source file is $infocontent !" ;
