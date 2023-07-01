#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Walk_a_directory/Recursively
use warnings;
use Path::Tiny;

path('.')->visit( sub {/\.c$/ and print "$_\n"}, {recurse => 1} );
