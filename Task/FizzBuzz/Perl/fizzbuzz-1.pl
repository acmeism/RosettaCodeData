#!/usr/bin/perl

use strict;
use warnings;

use feature qw/say/;

foreach my $i (1 .. 100) {
    say + (0 == $i % 15) ? "FizzBuzz"
        : (0 == $i % 3) ? "Fizz"
        : (0 == $i % 5) ? "Buzz"
        : $i
        ;
}
