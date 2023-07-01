put (flat 2, 3, 5, 7, sort +*, gather (3..9).map: &recurse ).batch(10)».fmt("%8d").join: "\n";

sub recurse ($str) {
    .take for ($str X~ (1, 3, 7)).grep: { .is-prime && [>] .comb };
    recurse $str × 10 + $_ for 2 ..^ $str % 10;
}
