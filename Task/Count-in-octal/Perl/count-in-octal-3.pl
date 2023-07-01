#!/usr/bin/perl

$_ = 0;
s/([^7])?(7*)$/ $1 + 1 . $2 =~ tr!7!0!r /e while print "$_\n";
