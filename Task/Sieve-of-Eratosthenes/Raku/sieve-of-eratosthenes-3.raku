sub sieve($n) {
    sort keys [⊖] map { $_, 2×$_ ... $n }, 2 .. $n
}
