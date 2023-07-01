use strict;
use warnings;
use feature 'say';

sub get_next {
    my($w,%wheels) = @_;
    my $wh = \@{$wheels{$w}}; # reference, not a copy
    my $value = $$wh[0][$$wh[1]];
    $$wh[1] = ($$wh[1]+1) % @{$$wh[0]};
    defined $wheels{$value} ? get_next($value,%wheels) : $value;
}

sub spin_wheels {
    my(%wheels) = @_;
    say "$_: " . join ', ', @{${$wheels{$_}}[0]} for sort keys %wheels;
    print get_next('A', %wheels) . ' ' for 1..20; print "\n\n";
}

spin_wheels(%$_) for
(
 {'A' => [['1', '2', '3'], 0]},
 {'A' => [['1', 'B', '2'], 0], 'B' => [['3', '4'], 0]},
 {'A' => [['1', 'D', 'D'], 0], 'D' => [['6', '7', '8'], 0]},
 {'A' => [['1', 'B', 'C'], 0], 'B' => [['3', '4'], 0], 'C' => [['5', 'B'], 0]},
);
