#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw( uniq );

my $deps = <<END;
top1    des1 ip1 ip2
top2    des1 ip2 ip3
ip1     extra1 ip1a ipcommon
ip2     ip2a ip2b ip2c ipcommon
des1    des1a des1b des1c
des1a   des1a1 des1a2
des1c   des1c1 extra1
END

sub before
  {
  map { $deps =~ /^$_\b(.+)/m ? before( split ' ', $1 ) : (), $_ } @_
  }

1 while $deps =~ s/^(\w+)\b.*?\K\h+\1\b//gm; # remove self dependencies
print "TOP LEVELS: @{[grep $deps !~ /\h$_\b/, $deps =~ /^\w+/gm]}\n";
print "\nTARGET $_ ORDER: @{[ uniq before split ]}\n"
  for $deps =~ /^\w+/gm, 'top1 top2';
