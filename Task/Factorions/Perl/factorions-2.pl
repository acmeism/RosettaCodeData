use 5.020;
use ntheory qw(:all);
use experimental qw(signatures);
use Algorithm::Combinatorics qw(combinations_with_repetition);

sub max_power ($base = 10) {
    my $m = 1;
    my $f = factorial($base - 1);
    while ($m * $f >= $base**($m-1)) {
        $m += 1;
    }
    return $m-1;
}

sub factorions ($base = 10) {

    my @result;
    my @digits    = (0 .. $base-1);
    my @factorial = map { factorial($_) } @digits;

    foreach my $k (1 .. max_power($base)) {
        my $iter = combinations_with_repetition(\@digits, $k);
        while (my $comb = $iter->next) {
            my $n = vecsum(map { $factorial[$_] } @$comb);
            if (join(' ', sort { $a <=> $b } todigits($n, $base)) eq join(' ', @$comb)) {
                push @result, $n;
            }
        }
    }

    return @result;
}

foreach my $base (2 .. 14) {
    my @r = factorions($base);
    say "Factorions in base $base are (@r)";
}
