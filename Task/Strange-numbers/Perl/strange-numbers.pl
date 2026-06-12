use strict;
use warnings;
use feature 'say';
use Quantum::Superpositions;

sub is_strange {
    my @digits = split '', $_;
    my @deltas = map { abs $digits[$_-1] - $digits[$_] } 1..$#digits;
    all(@deltas) == any(2, 3, 5, 7);
}

my($low, $high) = (100, 500);
my $cnt = my @strange = grep { is_strange($_) } $low+1 .. $high-1;
say "Between $low and $high there are $cnt strange numbers:\n" .
    (sprintf "@{['%5d' x $cnt]}", @strange[0..$cnt-1]) =~ s/(.{80})/$1\n/gr;
