def fib = { List seed, int k=10 ->
    assert seed : "The seed list must be non-null and non-empty"
    assert seed.every { it instanceof Number } : "Every member of the seed must be a number"
    def n = seed.size()
    assert n > 1 : "The seed must contain at least two elements"
    List result = [] + seed
    if (k < n) {
        result[0..k]
    } else {
        (n..k).inject(result) { res, kk ->
            res << res[-n..-1].sum()
        }
    }
}
