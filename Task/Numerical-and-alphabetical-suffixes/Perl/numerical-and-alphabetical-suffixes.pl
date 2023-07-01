#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Numerical_and_alphabetical_suffixes
use warnings;

my %suffix = qw( k 1e3 m 1e6 g 1e9 t 1e12 p 1e15 e 1e18 z 1e21 y 1e24 x 1e27
  w 1e30 v 1e33 u 1e36 ki 2**10 mi 2**20 gi 2**30 ti 2**40 pi 2**50 ei 2**60
  zi 2**70 yi 2**80 xi 2**90 wi 2**100 vi 2**110 ui 2**120 );

local $" = '  '; # strange rule...
print "numbers = ${_}results = @{[ map suffix($_), split ]}\n\n" while <DATA>;

sub suffix
  {
  my ($value, $mods) = shift =~ tr/,//dr =~ /([+-]?[\d.]+(?:e[+-]\d+)?)(.*)/i;
  $value *= $^R while $mods =~ /
      PAIRs?            (?{       2 })
    | SCO(re?)?         (?{      20 })
    | DOZ(e(ns?)?)?     (?{      12 })
    | GREATGR(o(ss?)?)? (?{    1728 }) # must be before GRoss
    | GR(o(ss?)?)?      (?{     144 })
    | GOOGOLs?          (?{ 10**100 })
    | [kmgtpezyxwvu]i?  (?{ eval $suffix{ lc $& } })
    | !+ (?{ my $factor = $value;
        $value *= $factor while ($factor -= length $&) > 1;
        1 })
    /gix;
  return $value =~ s/(\..*)|\B(?=(\d\d\d)+(?!\d))/$1 || ','/ger;
  }

__DATA__
2greatGRo   24Gros  288Doz  1,728pairs  172.8SCOre
1,567      +1.567k    0.1567e-2m
25.123kK    25.123m   2.5123e-00002G
25.123kiKI  25.123Mi  2.5123e-00002Gi  +.25123E-7Ei
-.25123e-34Vikki      2e-77gooGols
9!   9!!   9!!!   9!!!!   9!!!!!   9!!!!!!   9!!!!!!!   9!!!!!!!!   9!!!!!!!!!
