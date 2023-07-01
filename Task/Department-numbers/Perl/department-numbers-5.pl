#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Department_numbers
use warnings;

print "P S F\n\n";

print tr/+/ /r, "\n" for
  grep  !/(\d).*\1/ && 12 == eval,
  glob '{2,4,6}' . '+{1,2,3,4,5,6,7}' x 2;
