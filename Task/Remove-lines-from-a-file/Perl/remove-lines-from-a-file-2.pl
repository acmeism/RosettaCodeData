#!/usr/bin/perl -w
use strict ;
use Tie::File ;

sub deletelines {
   my $arguments = shift ;
   my( $file , $startfrom , $howmany ) = @{$arguments} ;
   tie my @lines , 'Tie::File' , $file or die "Can't find file $file!\n" ;
   my $nrecs = @lines ;
   if ( $startfrom > $nrecs ) {
      print "Error! Starting to delete lines past the end of the file!\n" ;
      return ;
   }
   if ( ( $startfrom + $howmany ) > $nrecs ) {
      print "Error! Trying to delete lines past the end of the file!\n" ;
      return ;
   }
   splice @lines , $startfrom - 1 , $howmany ;
   untie @lines ;
}

if ( @ARGV != 3 ) {
   print "Error! Invoke with deletelines <filename> <start> <skiplines> !\n" ;
   exit( 1 ) ;
}

deletelines( \@ARGV ) ;
