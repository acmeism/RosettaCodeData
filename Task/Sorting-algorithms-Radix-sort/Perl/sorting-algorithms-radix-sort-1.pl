#!/usr/bin/perl
use warnings;
use strict;

sub radix {
    my @tab = ([@_]);

    my $max_length = 0;
    length > $max_length and $max_length = length for @_;
    $_ = sprintf "%0${max_length}d", $_ for @{ $tab[0] }; # Add zeros.

    for my $pos (reverse -$max_length .. -1) {
        my @newtab;
        for my $bucket (@tab) {
            for my $n (@$bucket) {
                my $char = substr $n, $pos, 1;
                $char = -1 if '-' eq $char;
                $char++;
                push @{ $newtab[$char] }, $n;
            }
        }
        @tab = @newtab;
    }

    my @return;
    my $negative = shift @tab;                            # Negative bucket must be reversed.
    push @return, reverse @$negative;
    for my $bucket (@tab) {
        push @return, @{ $bucket // [] };
    }
    $_ = 0 + $_ for @return;                              # Remove zeros.
    return @return;
}
