load "stdlib.ring"

/* Searching for the smallest prime gaps under a limit,
   such that the difference of successive terms (gaps)
   is of the smallest degree. */

? "working..."

desc = split("na quadratic cubic quartic quintic sextic septic octic nonic decic"," ")
limits = [1, 16000, 15000, 30000, 50000, 50000, 50000, 75000, 300000, 500000]
for deg = 2 to len(desc)

    Primes = []
    limit = limits[deg]
    oldPrime = 2
    add(Primes, 2)

    for n = 1 to sqrt(limit)
        nextPrime = oldPrime + pow(n, deg)
        if isprime(nextPrime)
           n = 1
           if nextPrime < limit add(Primes, nextPrime) ok
           oldPrime = nextPrime
        else
           nextPrime = nextPrime - oldPrime
        ok
        if nextPrime > limit exit ok
    next

    ? nl + desc[deg] + ":" + nl + " prime1  prime2    Gap   Rt"
    for n = 1 to Len(Primes) - 1
        diff = Primes[n + 1] - Primes[n]
        ? sf(Primes[n], 7) + " " + sf(Primes[n+1], 7) + " " + sf(diff, 6) + " " + sf(floor(0.49 + pow(diff, 1 / deg)), 4)
    next

    ? "Found " + Len(Primes) + " primes under " + limit + " for " + desc[deg] + " gaps."
next
? nl + "done..."

# a very plain string formatter, intended to even up columnar outputs
def sf x, y
    s = string(x) l = len(s)
    if l > y y = l ok
    return substr("          ", 11 - y + l) + s
