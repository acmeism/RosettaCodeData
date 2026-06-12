sub digroot ($r) { .tail given $r, { [+] .comb } ... { .chars == 1 } }
my @is-nice = lazy (0..*).map: { .&is-prime && .&digroot.&is-prime ?? $_ !! False };
say @is-nice[500 ^..^ 1000].grep(*.so).batch(11)».fmt("%4d").join: "\n";
