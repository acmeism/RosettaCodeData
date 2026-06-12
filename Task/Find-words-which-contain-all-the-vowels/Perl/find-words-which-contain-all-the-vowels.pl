#!/usr/bin/perl

use strict;
use warnings;

@ARGV = 'unixdict.txt';
length > 11 and !/([aeiou]).*\1/ and tr/aeiou// == 5 and print while <>;
