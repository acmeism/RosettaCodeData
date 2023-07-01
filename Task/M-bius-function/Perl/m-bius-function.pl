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
    @p == uniq(@p) ? 0 == @p%2 ? 1 : -1 : 0;
}

my @möebius;
push @möebius, μ($_) for 1 .. (my $upto = 199);

say "Möbius sequence - First $upto terms:\n" .
    (' 'x4 . sprintf "@{['%4d' x $upto]}", @möebius) =~ s/((.){80})/$1\n/gr;
