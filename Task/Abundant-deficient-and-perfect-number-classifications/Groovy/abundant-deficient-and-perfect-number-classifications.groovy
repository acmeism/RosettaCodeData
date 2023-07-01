def dpaCalc = { factors ->
    def n = factors.pop()
    def fSum = factors.sum()
    fSum < n
        ? 'deficient'
        : fSum > n
            ? 'abundant'
            : 'perfect'
}

(1..20000).inject([deficient:0, perfect:0, abundant:0]) { map, n ->
    map[dpaCalc(factorize(n))]++
    map
}
.each { e -> println e }
