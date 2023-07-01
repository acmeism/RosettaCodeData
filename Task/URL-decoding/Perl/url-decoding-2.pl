#!/usr/bin/perl -w
use strict ;
use URI::Escape ;

my $encoded = "http%3A%2F%2Ffoo%20bar%2F" ;
my $unencoded = uri_unescape( $encoded ) ;
print "The unencoded string is $unencoded !\n" ;
