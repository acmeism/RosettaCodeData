#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Punched_cards
use warnings;

my @holes = split ' ', <<'END';
&.<(+|abcdefghijklmnopqrABCDEFGHI
-!$*);jklmnopqrstuvwxyzJKLMNOPQR
/,%_>?abcdedfghistuvwxyzSTUVWXYZ0
/ajAJ1
bksBKS2!:
cltCLT3.$,#
dmuDMU4<*%@
envENV5()_'
fowFOW6+;>=
gpxGPX7|?"
hqyHQY8!:.$,#<*%@()_'+;>=|?"
irzIRZ9
END

sub card
  {
  my @text = split //,  sprintf '%-80.80s', shift;
  print ' ', '_' x 80, "\n/", @text, "|\n";
  for my $row ( @holes )
    {
    print "|", map( { $row =~ /\Q$_/ ? 'X' : ' ' } @text ), "|\n";
    }
  print "|", '_' x 80, "|\n"
  }

card( '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' );
card( q{.<(+|&!$*);-/,%_>?:#@'="} );
card( q<perl -le 'print "Hello, World"'> );
