sub lex (Real $n, $step = 1) {
    ($n < 1 ?? ($n, * + $step …^ * > 1)
            !! ($n, * - $step …^ * < 1)).sort: ~*
}

# TESTING
for 13, 21, -22, (6, .333), (-4, .25), (-5*π, e) {
    my ($bound, $step) = |$_, 1;
    say "Boundary:$bound, Step:$step >> ", lex($bound, $step).join: ', ';
}
