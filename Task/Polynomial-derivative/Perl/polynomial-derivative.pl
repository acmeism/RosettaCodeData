use strict;
use warnings;
use feature 'say';
use utf8;
binmode(STDOUT, ':utf8');

sub pp {
    my(@p) = @_;
    return 0 unless @p;
    my @f = $p[0];
    push @f, ($p[$_] != 1 and $p[$_]) . 'x' . ($_ != 1 and (qw<⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹>)[$_])
        for grep { $p[$_] != 0 } 1 .. $#p;
    ( join('+', reverse @f) =~ s/-1x/-x/gr ) =~ s/\+-/-/gr
}

for ([5], [4,-3], [-1,3,-2,1], [-1,6,5], [1,1,0,-1,-1]) {
    my @poly = @$_;
    say 'Polynomial: ' . join(', ', @poly) . ' ==> ' . pp @poly;
    $poly[$_] *= $_ for 0 .. $#poly;
    shift @poly;
    say 'Derivative: ' . (@poly ? join', ', @poly : 0) . ' ==> ' . pp(@poly) . "\n";
}
