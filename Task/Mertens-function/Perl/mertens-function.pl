use utf8;
use strict;
use warnings;
use feature 'say';
use List::Util 'uniq';

sub prime_factors {
    my ($n, $d, @factors) = (shift, 1);
    while ($n > 1 and $d++) {
        $n /= $d, push @factors, $d until $n % $d;
    }
    @factors
}

sub μ {
    my @p = prime_factors(shift);
    @p == uniq(@p) ? 0 == @p%2 ? 1 : -1 : 0
}

sub progressive_sum {
    my @sum = shift @_;
    push @sum, $sum[-1] + $_ for @_;
    @sum
}

my($upto, $show, @möebius) = (1000, 199, ());
push @möebius, μ($_) for 1..$upto;
my @mertens = progressive_sum @möebius;

say "Mertens sequence - First $show terms:\n" .
    (' 'x4 . sprintf "@{['%4d' x $show]}", @mertens[0..$show-1]) =~ s/((.){80})/$1\n/gr .
    sprintf("\nEquals zero %3d times between 1 and $upto", scalar grep { ! $_ } @mertens) .
    sprintf "\nCrosses zero%3d times between 1 and $upto", scalar grep { ! $mertens[$_-1] and $mertens[$_] } 1 .. @mertens;
