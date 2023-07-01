primes = [2, 3, 5, 7, 11, 13, 17, 19, 23]

def isPrime(n):
    if n < 2:
        return False

    for i in primes:
        if n == i:
            return True
        if n % i == 0:
            return False
        if i * i > n:
            return True
    print "Oops,", n, " is too large"

def init():
    s = 24
    while s < 600:
        if isPrime(s - 1) and s - 1 > primes[-1]:
            primes.append(s - 1)
        if isPrime(s + 1) and s + 1 > primes[-1]:
            primes.append(s + 1)
        s += 6

def nsmooth(n, size):
    if n < 2 or n > 521:
        raise Exception("n")
    if size < 1:
        raise Exception("n")

    bn = n
    ok = False
    for prime in primes:
        if bn == prime:
            ok = True
            break
    if not ok:
        raise Exception("must be a prime number: n")

    ns = [0] * size
    ns[0] = 1

    next = []
    for prime in primes:
        if prime > bn:
            break
        next.append(prime)

    indicies = [0] * len(next)
    for m in xrange(1, size):
        ns[m] = min(next)
        for i in xrange(0, len(indicies)):
            if ns[m] == next[i]:
                indicies[i] += 1
                next[i] = primes[i] * ns[indicies[i]]

    return ns

def main():
    init()

    for p in primes:
        if p >= 30:
            break
        print "The first", p, "-smooth numbers are:"
        print nsmooth(p, 25)
        print

    for p in primes[1:]:
        if p >= 30:
            break
        print "The 3000 to 3202", p, "-smooth numbers are:"
        print nsmooth(p, 3002)[2999:]
        print

    for p in [503, 509, 521]:
        print "The 30000 to 3019", p, "-smooth numbers are:"
        print nsmooth(p, 30019)[29999:]
        print

main()
