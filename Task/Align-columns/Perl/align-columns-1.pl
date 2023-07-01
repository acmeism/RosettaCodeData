#/usr/bin/perl -w
use strict ;

die "Call : perl columnaligner.pl <inputfile> <printorientation>!\n" unless
   @ARGV == 2 ; #$ARGV[ 0 ] contains example file , $ARGV[1] any of 'left' , 'right' or 'center'
die "last argument must be one of center, left or right!\n" unless
   $ARGV[ 1 ] =~ /center|left|right/ ;
sub printLines( $$$ ) ;
open INFILE , "<" , "$ARGV[ 0 ]" or die "Can't open $ARGV[ 0 ]!\n" ;
my @lines = <INFILE> ;
close INFILE ;
chomp @lines ;
my @fieldwidths = map length, split /\$/ , $lines[ 0 ] ;
foreach my $i ( 1..$#lines ) {
   my @words = split /\$/ , $lines[ $i ] ;
   foreach my $j ( 0..$#words ) {
      if ( $j <= $#fieldwidths ) {
         if ( length $words[ $j ] > $fieldwidths[ $j ] ) {
               $fieldwidths[ $j ] = length $words[ $j ] ;
         }
      }
      else {
         push @fieldwidths, length $words[ $j ] ;
      }
   }
}
printLine( $_ , $ARGV[ 1 ] , \@fieldwidths ) foreach @lines ;
##################################################################    ####
sub printLine {
   my $line = shift ;
   my $orientation = shift ;
   my $widthref = shift ;
   my @words = split /\$/, $line ;
   foreach my $k ( 0..$#words ) {
      my $printwidth = $widthref->[ $k ] + 1 ;
      if ( $orientation eq 'center' ) {
         $printwidth++ ;
      }
      if ( $orientation eq 'left' ) {
         print $words[ $k ] ;
         print " " x ( $printwidth - length $words[ $k ] ) ;
      }
      elsif ( $orientation eq 'right' ) {
         print " " x ( $printwidth - length $words[ $k ] ) ;
         print $words[ $k ] ;
      }
      elsif ( $orientation eq 'center' ) {
         my $left = int( ( $printwidth - length $words[ $k ] )     / 2 ) ;
         my $right = $printwidth - length( $words[ $k ] ) - $left      ;
         print " " x $left ;
         print $words[ $k ] ;
         print " " x $right ;
      }
   }
   print "\n" ;
}
