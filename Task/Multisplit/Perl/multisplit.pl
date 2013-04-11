#!/usr/bin/perl -w
use strict ;
sub multisplit {
   my ( $string , $pattern ) = @_ ;
   split( /($pattern)/, $string, -1 ) ;
}

my $phrase = "a!===b=!=c" ;
my $pattern = "==|!=|=" ;
print "$_ ," foreach multisplit( $phrase , $pattern ) ;
print "\n" ;
