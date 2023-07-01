#!/usr/bin/perl

use strict;   # Not necessary but considered good perl style
use warnings; # this one too

print "Police\t-\tFire\t-\tSanitation\n";
for my $p ( 1..7 )  # Police Department
{
  for my $f ( 1..7) # Fire Department
  {
    for my $s ( 1..7 ) # Sanitation Department
    {
      if ( $p % 2 == 0 && $p + $f + $s == 12 && $p != $f && $f != $s  && $s != $p && $f != $s) # Check if the combination of numbers is valid
      {
        print "$p\t-\t$f\t-\t$s\n";
      }
    }
  }
}
