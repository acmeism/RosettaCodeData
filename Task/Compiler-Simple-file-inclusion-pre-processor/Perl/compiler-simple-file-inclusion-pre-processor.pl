#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Compiler/Simple_file_inclusion_pre_processor
use warnings;
use Path::Tiny;

local $_ = join '', <>;
s/^#include\h+"(.*?)".*\n/path($1)->slurp/gem for ($_) x 10;
print;
