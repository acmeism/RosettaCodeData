#!/usr/bin/perl
use warnings;
use strict;
use 5.010; # //

use List::Util qw( shuffle );

my @colours = qw( blue white red );

sub are_ordered {
    my $balls = shift;
    my $last = 0;
    for my $ball (@$balls) {
        return if $ball < $last;
        $last = $ball;
    }
    return 1;
}


sub show {
    my $balls = shift;
    print join(' ', map $colours[$_], @$balls), "\n";
}


sub debug {
    return unless $ENV{DEBUG};

    my ($pos, $top, $bottom, $balls) = @_;
    for my $i (0 .. $#$balls) {
        my ($prefix, $suffix) = (q()) x 2;

        ($prefix, $suffix) = qw/( )/ if $i == $pos;
        $prefix           .= '>'     if $i == $top;
        $suffix           .= '<'     if $i == $bottom;

        print STDERR " $prefix$colours[$balls->[$i]]$suffix";
    }
    print STDERR "\n";
}


my $count = shift // 10;
die "$count: Not enough balls\n" if $count < 3;

my $balls = [qw( 2 1 0 )];
push @$balls, int rand 3 until @$balls == $count;
do { @$balls = shuffle @$balls } while are_ordered($balls);

show($balls);

my $top    = 0;
my $bottom = $#$balls;

my $i = 0;
while ($i <= $bottom) {
    debug($i, $top, $bottom, $balls);
    my $col = $colours[ $balls->[$i] ];
    if ('red' eq $col and $i < $bottom) {
        @{$balls}[$bottom, $i] = @{$balls}[$i, $bottom];
        $bottom--;
    } elsif ('blue' eq $col and $i > $top) {
        @{$balls}[$top, $i] = @{$balls}[$i, $top];
        $top++;
    } else {
        $i++;
    }
}
debug($i, $top, $bottom, $balls);

show($balls);
are_ordered($balls) or die "Incorrect\n";
