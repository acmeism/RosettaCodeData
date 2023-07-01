use strict;
use warnings;
use feature 'say';

sub linear_combination {
    my(@coef) = @$_;
    my $e = '';
    for my $c (1..+@coef) { $e .= "$coef[$c-1]*e($c) + " if $coef[$c-1] }
    $e =~ s/ \+ $//;
    $e =~ s/1\*//g;
    $e =~ s/\+ -/- /g;
    $e or 0;
}

say linear_combination($_) for
  [1, 2, 3], [0, 1, 2, 3], [1, 0, 3, 4], [1, 2, 0], [0, 0, 0], [0], [1, 1, 1], [-1, -1, -1], [-1, -2, 0, -3], [-1 ]
