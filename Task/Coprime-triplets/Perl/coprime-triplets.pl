use strict;
use warnings;
use feature <state say>;
use ntheory 'gcd';
use List::Util 'first';
use List::Lazy 'lazy_list';
use enum qw(False True);
use constant Inf => 1e5;

my $ct = lazy_list {
    state @c = (1, 2);
    state %seen = (1 => True, 2 => True);
    state $min = 3;
    my $g = $c[-2] * $c[-1];
    my $n = first { !$seen{$_} and gcd($_,$g) == 1 } $min .. Inf;
    $seen{$n} = True;
    $min = first { !$seen{$_} } $min .. Inf;
    push @c, $n;
    shift @c
};

my @ct;
do { push @ct, $ct->next() } until $ct[-1] > 50; pop @ct;
say join ' ', @ct
