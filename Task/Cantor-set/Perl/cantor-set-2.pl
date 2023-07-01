#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/Cantor_set
use warnings;

$_ = '#' x 81;

1 while print, s/(#+)\1\1/ $1 . $1 =~ tr!#! !r . $1 /ge;
