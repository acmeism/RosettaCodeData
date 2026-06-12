unit sub MAIN ($limit = 500);
say "{+$_} reversible primes < $limit:\n{$_».fmt("%" ~ $limit.chars ~ "d").batch(10).join("\n")}",
    with ^$limit .grep: { .is-prime and .flip.is-prime }
