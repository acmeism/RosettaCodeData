let mP = seq {
    let mutable prevp, maxdiff = 2, 0
    for p in primes32() do
        let diff = p - prevp
        if diff > maxdiff then
            yield (prevp, diff, p)
            maxdiff <- diff
            prevp <- p
}
