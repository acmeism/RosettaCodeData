#!/usr/bin/perl
use strict ;
use warnings ;
use DateTime ;

for my $i( 1..12 ) {
   my $date = DateTime->last_day_of_month( year => $ARGV[ 0 ] ,
	 month => $i ) ;
   while ( $date->dow != 7 ) {
      $date = $date->subtract( days => 1 ) ;
   }
   my $ymd = $date->ymd ;
   print "$ymd\n" ;
}
