#!/usr/bin/perl

use strict;
use warnings;
use Data::Dump qw(dd pp);

my @tests =
  (
  []
  ,[1, 2, 4]
  ,[3, 1, 3, 1]
  ,[1, 2, 3, 1]
  ,[3, 2, 1, 3]
  ,[3, 3, 3, 1, 1, 3, 3, 3]
  );

for my $before ( @tests )
  {
  dd { before => $before };
  local $_ = (pp $before) =~ s/\d+/ '['x($&-1) . $& . ']'x($&-1) /ger;
  1 while s/\](,\s*)\[/$1/;
  my $after = eval;
  dd { after => $after };
  }
