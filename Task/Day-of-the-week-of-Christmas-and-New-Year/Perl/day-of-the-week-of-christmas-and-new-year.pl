#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/What_weekdays_will_Christmas_and_New_Year
use warnings;
use Time::Local;

for (
  ['Christmas 2021', 25, 11, 2021 ],
  ['New Years 2022', 1, 0, 2022 ],
  )
  {
  print "$_->[0] ", qw( Sunday Monday Tuesday Wednesday Thursday Fridat Saturday )
    [(localtime timelocal(0, 0, 12, @{$_}[1..3]))[6]], "\n";
  }
