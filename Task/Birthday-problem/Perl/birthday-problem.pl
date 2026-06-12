use strict;
use warnings;
use List::AllUtils qw(max min uniqnum count_by any);
use Math::Random qw(random_uniform_integer);

sub simulation {
    my($c) = shift;
    my $max_trials = 1_000_000;
    my $min_trials =    10_000;
    my $n = int 47 * ($c-1.5)**1.5; # OEIS/A050256: 16 86 185 307
    my $N = min $max_trials, max $min_trials, 1000 * sqrt $n;

    while (1) {
        my $yes = 0;
        for (1..$N) {
            my %birthday_freq = count_by { $_ } random_uniform_integer($n, 1, 365);
            $yes++ if any { $birthday_freq{$_} >= $c } keys %birthday_freq;
        }
        my $p = $yes/$N;
        return($n, $p) if $p > 0.5;
        $N = min $max_trials, max $min_trials, int 1000/(0.5-$p)**1.75;
        $n++;
    }
}

printf "$_ people in a group of %s share a common birthday. (%.4f)\n", simulation($_) for 2..5
