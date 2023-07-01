#!/usr/bin/perl

use strict;
use warnings;

$_ = <<END;

    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      ID                       |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    QDCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ANCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    NSCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ARCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

END

my $template;
my @names;
while( /\| *(\w+) */g )
  {
  printf "%10s is %2d bits\n", $1, my $length = length($&) / 3;
  push @names, $1;
  $template .= "A$length ";
  }

my $input = '78477bbf5496e12e1bf169a4'; # as hex

my %datastructure;
@datastructure{ @names } = unpack $template, unpack 'B*', pack 'H*', $input;

print "\ntemplate = $template\n\n";
use Data::Dump 'dd'; dd 'datastructure', \%datastructure;
