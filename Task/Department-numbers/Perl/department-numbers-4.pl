#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Department_numbers
use warnings;

print "P S F\n\n";

'246 1234567 1234567' =~
  /(.).* \s .*?(?!\1)(.).* \s .*(?!\1)(?!\2)(.)
  (??{$1+$2+$3!=12})
  (?{ print "@{^CAPTURE}\n" })(*FAIL)/x;
