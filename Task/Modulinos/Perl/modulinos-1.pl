#!/usr/bin/env perl

# Life.pm
package Life;

use strict;
use warnings;

sub meaning_of_life {
	return 42;
}

unless(caller) {
	print "Main: The meaning of life is " . meaning_of_life() . "\n";
}
