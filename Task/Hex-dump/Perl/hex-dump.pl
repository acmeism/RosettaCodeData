#!/usr/bin/perl
use strict;
use warnings;

use constant BUFFER_LENGTH => 1024;

my ( $filename, $offset, $limit ) = @ARGV;
if ( !defined($filename) ) {
    print "Usage: $0 [FILENAME] [OFFSET] [LIMIT]\n";
    exit;
}
if ( !defined($offset) ) {
    $offset = 0;
}
if ( !defined($limit) ) {
    $limit = -1;
}

my $fh;
open $fh, "<", $filename or die "error opening $filename";
binmode $fh;

if ( $offset > 0 ) {
    seek $fh, $offset, 0;
}
my $current_offset = $offset;

my $read_size = BUFFER_LENGTH;
if ( $limit > 0 && $limit < BUFFER_LENGTH ) {
    $read_size = $limit;
}

my $buffer;
while ( read( $fh, $buffer, $read_size ) ) {
    for ( my $start = 0 ; $start < length($buffer) ; $start += 16 ) {
        my @hex = ( sprintf( "%08x ", $start + $current_offset ) );
        my @chars;

        for (
            my $pos = $start ;
            $pos < $start + 16 && $pos < length($buffer) ;
            $pos++
          )
        {
            my $ch  = substr( $buffer, $pos, 1 );
            my $val = ord($ch);
            push @hex, sprintf( "%02x ", $val );
            if ( $pos == $start + 7 ) {
                push @hex, " ";
            }
            if ( $val >= 20 && $val <= 126 ) {
                push @chars, $ch;
            }
            else {
                push @chars, ".";
            }
        }

        printf( "%-60s  |%s|\n", join( "", @hex ), join( "", @chars ) );
    }

    $current_offset += length($buffer);

    if ( $limit != -1 ) {
        $limit -= length($buffer);
        if ( $limit == 0 ) {
            last;
        }
        if ( $read_size > $limit ) {
            $read_size = $limit;
        }
    }
}
printf( "%08x\n", $current_offset );
