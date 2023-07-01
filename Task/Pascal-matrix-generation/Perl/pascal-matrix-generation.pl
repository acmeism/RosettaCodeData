#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };


sub upper {
    my ($i, $j) = @_;
    my @m;
    for my $x (0 .. $i - 1) {
        for my $y (0 .. $j - 1) {
            $m[$x][$y] = $x > $y          ? 0
                       : ! $x || $x == $y ? 1
                                          : $m[$x-1][$y-1] + $m[$x][$y-1];
        }
    }
    return \@m
}


sub lower {
    my ($i, $j) = @_;
    my @m;
    for my $x (0 .. $i - 1) {
        for my $y (0 .. $j - 1) {
            $m[$x][$y] = $x < $y          ? 0
                       : ! $x || $x == $y ? 1
                                          : $m[$x-1][$y-1] + $m[$x-1][$y];
        }
    }
    return \@m
}


sub symmetric {
    my ($i, $j) = @_;
    my @m;
    for my $x (0 .. $i - 1) {
        for my $y (0 .. $j - 1) {
            $m[$x][$y] = ! $x || ! $y ? 1
                                      : $m[$x-1][$y] + $m[$x][$y-1];
        }
    }
    return \@m
}


sub pretty {
    my $m = shift;
    for my $row (@$m) {
        say join ', ', @$row;
    }
}


pretty(upper(5, 5));
say '-' x 14;
pretty(lower(5, 5));
say '-' x 14;
pretty(symmetric(5, 5));
