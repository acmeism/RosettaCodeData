def par_primes():
    "Prime number generator from the partition machine"
    p = [1]
    p_m = plus_minus()
    mods = []
    n = 0
    while True:
        n += 1
        next_plus_minus = next(p_m)
        if next_plus_minus:
            mods.append(next_plus_minus)
        p.append(sum(p[offset] * sign for offset, sign in mods))
        if p[0] + 1 == p[-1]:
            yield p[0]
        p[0] += 1
    yield p

print("\nPrimes:", list(islice(par_primes(), 15)))
