#!/usr/bin/perl
use 5.010 ;
use strict ;
use warnings ;
use Digest::CRC qw( crc32 ) ;

my $crc = Digest::CRC->new( type => "crc32" ) ;
$crc->add ( "The quick brown fox jumps over the lazy dog" )  ;
say "The checksum is " . $crc->hexdigest( ) ;
