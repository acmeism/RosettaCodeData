unit sub MAIN ($limit = 500);
say "{+$_} additive primes < $limit:\n{$_».fmt("%" ~ $limit.chars ~ "d").batch(10).join("\n")}",
    with ^$limit .grep: { .is-prime && .comb.sum.is-prime }
