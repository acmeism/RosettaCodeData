#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/Concurrent_computing
use warnings;
use Time::HiRes qw( sleep );

fork or sleep(rand), exit print for qw(Enjoy Rosetta Code);
1 while wait > 0;
