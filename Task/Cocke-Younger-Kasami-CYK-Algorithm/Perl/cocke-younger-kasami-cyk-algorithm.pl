#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

# rosettacode.org/wiki/Cocke-Younger-Kasami_(CYK)_Algorithm

# CYK parser implementation. Returns true if w is valid CYK under r rules.
sub cyk_parse {
    my ($w, $r, $startcode) = @_;
    $startcode //= "NP";
    my $n = scalar @$w;

    # Initialize table t as a 2D array of sets (represented as hashes)
    my @t;
    for my $i (0 .. $n - 1) {
        for my $j (0 .. $n - 1) {
            $t[$i][$j] = {};
        }
    }

    # Main CYK algorithm
    for my $j (0 .. $n - 1) {
        # Check for terminal rules
        for my $lhs (keys %$r) {
            for my $rhs (@{$r->{$lhs}}) {
                if (@$rhs == 1 && $rhs->[0] eq $w->[$j]) {
                    $t[$j][$j]{$lhs} = 1;
                }
            }
        }

        # Check for non-terminal rules
        for (my $i = $j; $i >= 0; $i--) {
            for (my $k = $i; $k < $j; $k++) {
                for my $lhs (keys %$r) {
                    for my $rhs (@{$r->{$lhs}}) {
                        if (@$rhs == 2) {
                            my $rhs1 = $rhs->[0];
                            my $rhs2 = $rhs->[1];
                            if ($t[$i][$k]{$rhs1} && $t[$k + 1][$j]{$rhs2}) {
                                $t[$i][$j]{$lhs} = 1;
                            }
                        }
                    }
                }
            }
        }
    }

    return exists $t[0][$n - 1]{$startcode};
}

# Test the CYK parser with a sample grammar and input string.
# start code: "NP"
# non_terminals: ["NP", "Nom", "Det", "AP", "Adv", "A"]
# terminals: ["book", "orange", "man", "tall", "heavy", "very", "muscular"]
sub testCYK {
    my $r = {
        NP => [
            ["Det", "Nom"]
        ],
        Nom => [
            ["AP", "Nom"],
            ["book"],
            ["orange"],
            ["man"]
        ],
        AP => [
            ["Adv", "A"],
            ["heavy"],
            ["orange"],
            ["tall"]
        ],
        Det => [
            ["a"]
        ],
        Adv => [
            ["very"],
            ["extremely"]
        ],
        A => [
            ["heavy"],
            ["orange"],
            ["tall"],
            ["muscular"]
        ]
    };

    my $w = [split /\s+/, "a very heavy orange book"];
    return cyk_parse($w, $r, "NP");
}

say "testCYK result: ", testCYK() ? "true" : "false";
