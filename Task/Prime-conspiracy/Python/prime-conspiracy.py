def isPrime(n):
    if n < 2:
        return False
    if n % 2 == 0:
        return n == 2
    if n % 3 == 0:
        return n == 3

    d = 5
    while d * d <= n:
        if n % d == 0:
            return False
        d += 2

        if n % d == 0:
            return False
        d += 4
    return True

def generatePrimes():
    yield 2
    yield 3

    p = 5
    while p > 0:
        if isPrime(p):
            yield p
        p += 2
        if isPrime(p):
            yield p
        p += 4

g = generatePrimes()
transMap = {}
prev = None
limit = 1000000
for _ in xrange(limit):
    prime = next(g)
    if prev:
        transition = (prev, prime %10)
        if transition in transMap:
            transMap[transition] += 1
        else:
            transMap[transition] = 1
    prev = prime % 10

print "First {:,} primes. Transitions prime % 10 > next-prime % 10.".format(limit)
for trans in sorted(transMap):
    print "{0} -> {1} count {2:5} frequency: {3}%".format(trans[0], trans[1], transMap[trans], 100.0 * transMap[trans] / limit)
