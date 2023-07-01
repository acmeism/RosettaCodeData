#! /usr/bin/perl -w

use DateTime;
use strict;

for (2008 .. 2121) {
  print "25 Dec $_ is Sunday\n"
    if DateTime->new(year => $_, month => 12, day => 25)->day_of_week == 7;
}

exit 0;
