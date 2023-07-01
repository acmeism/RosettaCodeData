#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Vogel%27s_approximation_method
use warnings;
use List::AllUtils qw( max_by nsort_by min );

my $data = <<END;
A=30 B=20 C=70 D=30 E=60
W=50 X=60 Y=50 Z=50
AW=16 BW=16 CW=13 DW=22 EW=17
AX=14 BX=14 CX=13 DX=19 EX=15
AY=19 BY=19 CY=20 DY=23 EY=50
AZ=50 BZ=12 CZ=50 DZ=15 EZ=11
END
my $table = sprintf +('%4s' x 6 . "\n") x 5,
  map {my $t = $_; map "$_$t", '', 'A' .. 'E' } '' , 'W' .. 'Z';

my ($cost, %assign) = (0);
while( $data =~ /\b\w=\d/ )
  {
  my @penalty;
  for ( $data =~ /\b(\w)=\d/g )
    {
    my @all = map /(\d+)/, nsort_by { /\d+/ && $& }
      grep { my ($t, $c) = /(.)(.)=/; $data =~ /\b$c=\d/ and $data =~ /\b$t=\d/ }
      $data =~ /$_\w=\d+|\w$_=\d+/g;
    push @penalty, [ $_, ($all[1] // 0) - $all[0] ];
    }
  my $rc = (max_by { $_->[1] } nsort_by
    { my $x = $_->[0]; $data =~ /(?:$x\w|\w$x)=(\d+)/ && $1 } @penalty)->[0];
  my @lowest = nsort_by { /\d+/ && $& }
    grep { my ($t, $c) = /(.)(.)=/; $data =~ /\b$c=\d/ and $data =~ /\b$t=\d/ }
    $data =~ /$rc\w=\d+|\w$rc=\d+/g;
  my ($t, $c) = $lowest[0] =~ /(.)(.)/;
  my $allocate = min $data =~ /\b[$t$c]=(\d+)/g;
  $table =~ s/$t$c/ sprintf "%2d", $allocate/e;
  $cost += $data =~ /$t$c=(\d+)/ && $1 * $allocate;
  $data =~ s/\b$_=\K\d+/ $& - $allocate || '' /e for $t, $c;
  }
print "cost $cost\n\n", $table =~ s/[A-Z]{2}/--/gr;
