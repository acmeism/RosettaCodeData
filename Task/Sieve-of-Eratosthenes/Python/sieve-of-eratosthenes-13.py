def primes():
    for p in [2,3,5,7]: yield p                 # base wheel primes
    gaps1 = [ 2,4,2,4,6,2,6,4,2,4,6,6,2,6,4,2,6,4,6,8,4,2,4,2,4,8 ]
    gaps = gaps1 + [ 6,4,6,2,4,6,2,6,6,4,2,4,6,2,6,4,2,4,2,10,2,10 ] # wheel2357
    def wheel_prime_pairs():
        yield (11,0); bps = wheel_prime_pairs() # additional primes supply
        p, pi = next(bps); q = p * p            # adv to get 11 sqr'd is 121 as next square to put
        sieve = {}; n = 13; ni = 1              #   into sieve dict; init cndidate, wheel ndx
        while True:
            if n not in sieve:                  # is not a multiple of previously recorded primes
                if n < q: yield (n, ni)         # n is prime with wheel modulo index
                else:
                    npi = pi + 1                # advance wheel index
                    if npi > 47: npi = 0
                    sieve[q + p * gaps[pi]] = (p, npi) # n == p * p: put next cull position on wheel
                    p, pi = next(bps); q = p * p  # advance next prime and prime square to put
            else:
                s, si = sieve.pop(n)
                nxt = n + s * gaps[si]          # move current cull position up the wheel
                si = si + 1                     # advance wheel index
                if si > 47: si = 0
                while nxt in sieve:             # ensure each entry is unique by wheel
                    nxt += s * gaps[si]
                    si = si + 1                 # advance wheel index
                    if si > 47: si = 0
                sieve[nxt] = (s, si)            # next non-marked multiple of a prime
            nni = ni + 1                        # advance wheel index
            if nni > 47: nni = 0
            n += gaps[ni]; ni = nni             # advance on the wheel
    for p, pi in wheel_prime_pairs(): yield p   # strip out indexes
