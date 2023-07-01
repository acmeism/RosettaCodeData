def sieve(limit):
    primes = []
    c = [False] * (limit + 1) # composite = true
    # no need to process even numbers
    p = 3
    while True:
        p2 = p * p
        if p2 > limit: break
        for i in range(p2, limit, 2 * p): c[i] = True
        while True:
            p += 2
            if not c[p]: break

    for i in range(3, limit, 2):
        if not c[i]: primes.append(i)
    return primes

# finds the period of the reciprocal of n
def findPeriod(n):
    r = 1
    for i in range(1, n): r = (10 * r) % n
    rr = r
    period = 0
    while True:
        r = (10 * r) % n
        period += 1
        if r == rr: break
    return period

primes = sieve(64000)
longPrimes = []
for prime in primes:
    if findPeriod(prime) == prime - 1:
        longPrimes.append(prime)
numbers = [500, 1000, 2000, 4000, 8000, 16000, 32000, 64000]
count = 0
index = 0
totals = [0] * len(numbers)
for longPrime in longPrimes:
    if longPrime > numbers[index]:
        totals[index] = count
        index += 1
    count += 1
totals[-1] = count
print('The long primes up to 500 are:')
print(str(longPrimes[:totals[0]]).replace(',', ''))
print('\nThe number of long primes up to:')
for (i, total) in enumerate(totals):
    print('  %5d is %d' % (numbers[i], total))
