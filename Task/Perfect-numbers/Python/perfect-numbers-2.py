from itertools import chain, cycle, accumulate

def factor2(n):
    def prime_powers(n):
        # c goes through 2, 3, 5, then the infinite (6n+1, 6n+5) series
        for c in accumulate(chain([2, 1, 2], cycle([2,4]))):
            if c*c > n: break
            if n%c: continue
            d,p = (), c
            while not n%c:
                n,p,d = n//c, p*c, d + (p,)
            yield(d)
        if n > 1: yield((n,))

    r = [1]
    for e in prime_powers(n):
        r += [a*b for a in r for b in e]
    return r

def perf4(n):
    "Using most efficient prime factoring routine from: http://rosettacode.org/wiki/Factors_of_an_integer#Python"
    return 2 * n == sum(factor2(n))
