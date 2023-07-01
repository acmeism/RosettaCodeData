put (flat 2, 3, 5, 7, sort +*, gather (1..8).map: &recurse ).batch(10)».fmt("%8d").join: "\n";

sub recurse ($str) {
    .take for ($str X~ (3, 7, 9)).grep: { .is-prime && [<] .comb };
    recurse $str × 10 + $_ for $str % 10 ^.. 9;
}

printf "%.3f seconds", now - INIT now;
