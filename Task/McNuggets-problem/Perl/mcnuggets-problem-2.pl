use strict;
use warnings;

$_ = 1 . 0 x 100;
1 while s/ (?=1) (?:.{6}|.{9}|.{20}) \K 0 /1/x;
/01*$/ and print "Maximum non-Mcnugget number is: $-[0]\n";
