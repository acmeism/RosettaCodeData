#! /usr/bin/perl -w

use DateTime;
use strict;

print join " ", grep { DateTime->new(year => $_, month => 12, day => 25)->day_of_week == 7 } (2008 .. 2121);

0;
