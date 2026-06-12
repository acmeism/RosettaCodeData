#!/usr/bin/perl

use strict;
use warnings;
use ntheory qw( is_square );

print join( ' ', grep $_ & 1 && is_square($_), 100 .. 999 ), "\n";
