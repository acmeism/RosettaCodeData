#!/usr/bin/perl
use strict ;
use warnings ;

sub kelvin_to_other_scales {
   my $kelvin = shift ;
   my $celsius = $kelvin - 273.15 ;
   my $rankine = 9 * $kelvin / 5 ;
   my $fahrenheit = $rankine - 459.67 ;
   my @scales ;
   push @scales , $kelvin , $celsius , $fahrenheit , $rankine ;
   return @scales ;
}

print "Enter a temperature in Kelvin: " ;
my $kelvin = <STDIN> ;
chomp $kelvin ;
while ( $kelvin < 0 ) {
   print "Error! There are no negative kelvin degrees!\n" ;
   $kelvin = <STDIN> ;
   chomp $kelvin ;
}
my @scales = kelvin_to_other_scales( $kelvin ) ;
print "K $scales[ 0 ]\n" ;
print "C $scales[ 1 ]\n" ;
print "F $scales[ 2 ]\n" ;
print "R $scales[ 3 ]\n" ;
