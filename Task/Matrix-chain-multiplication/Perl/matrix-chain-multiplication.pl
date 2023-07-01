use strict;
use feature 'say';

sub matrix_mult_chaining {
    my(@dimensions) = @_;
    my(@cp,@path);

    # a matrix never needs to be multiplied with itself, so it has cost 0
    $cp[$_][$_] = 0 for keys @dimensions;

    my $n = $#dimensions;
    for my $chain_length (1..$n) {
        for my $start (0 .. $n - $chain_length - 1) {
            my $end = $start + $chain_length;
            $cp[$end][$start] = 10e10;
            for my $step ($start .. $end - 1) {
                my $new_cost = $cp[$step][$start]
                             + $cp[$end][$step + 1]
                             + $dimensions[$start] * $dimensions[$step+1] * $dimensions[$end+1];
                if ($new_cost < $cp[$end][$start]) {
                    $cp[$end][$start] = $new_cost; # cost
                    $cp[$start][$end] = $step;     # path
                }
            }
       }
    }

    $cp[$n-1][0] . ' ' . find_path(0, $n-1, @cp);
}

sub find_path {
    my($start,$end,@cp) = @_;
    my $result;

    if ($start == $end) {
        $result .= 'A' . ($start + 1);
    } else {
        $result .= '(' .
                   find_path($start, $cp[$start][$end], @cp) .
                   find_path($cp[$start][$end] + 1, $end, @cp) .
                   ')';
    }
    return $result;
}

say matrix_mult_chaining(<1 5 25 30 100 70 2 1 100 250 1 1000 2>);
say matrix_mult_chaining(<1000 1 500 12 1 700 2500 3 2 5 14 10>);
