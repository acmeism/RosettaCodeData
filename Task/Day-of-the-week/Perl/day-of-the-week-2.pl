#! /usr/bin/perl -w

use DateTime;
use strict;

foreach my $i (2008 .. 2121)
{
  my $dt = DateTime->new( year   => $i,
                          month  => 12,
                          day    => 25
                        );
  if ( $dt->day_of_week == 7 )
  {
    print "25 Dec $i is Sunday\n";
  }
}

exit 0;
