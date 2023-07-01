#! /usr/bin/perl
use strict;

sub counting_sort
{
    my ($a, $min, $max) = @_;

    my @cnt = (0) x ($max - $min + 1);
    $cnt[$_ - $min]++ foreach @$a;

    my $i = $min;
    @$a = map {($i++) x $_} @cnt;
}
