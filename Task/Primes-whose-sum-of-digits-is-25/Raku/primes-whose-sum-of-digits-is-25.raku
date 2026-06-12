unit sub MAIN ($limit = 5000);
say "{+$_} primes < $limit with digital sum 25:\n{$_».fmt("%" ~ $limit.chars ~ "d").batch(10).join("\n")}",
    with ^$limit .grep: { .is-prime and .comb.sum == 25 }
