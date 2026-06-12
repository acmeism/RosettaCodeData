#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Lempel%E2%80%93Ziv_complexity
use warnings;

print "want - got  as dotted notation\n";
for( split /\n/, <<END )
    "AZSEDRFTGYGUJIJOKB" 	16
    "ABCABCABCABCABCABC" 	4
    "111011111001111011111001" 	6
    "101001010010111110" 	5
    "1001111011000010" 	6
    "1010101010" 	3
    "1010101010101010" 	3
    "1001111011000010000010" 	7
    "100111101100001000001010" 	8
    "0001101001000101" 	6
    "1111111" 	2
    "0001" 	2
    "010" 	3
    "1" 	1
    "" (the empty string) 	0
    "01011010001101110010" 	7
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 	26
    "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!" 	11
END
  {
  my ($string, $want) = /"(.*)"\h*(\d+)/;
  my @parts;
  length $string or print("   0 -  0\n") , next;
  push @parts, $& while $string =~ /\G.+?(??{ "$`$&" =~ m<$&.> && '(*F)' })/gc;
  $string =~ /\G.+/gc and push @parts, $&;
  printf "%4d - %2d   %s\n", $want, scalar @parts, join '.', @parts;
  }
