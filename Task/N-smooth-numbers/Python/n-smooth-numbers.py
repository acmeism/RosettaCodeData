smallprimes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
primes = smallprimes.copy()

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
    print(f"Oops, {n} is too large")

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

    indices = [0] * len(next)
    for m in range(1, size):
        ns[m] = min(next)
        for i in range(len(indices)):
            if ns[m] == next[i]:
                indices[i] += 1
                next[i] = primes[i] * ns[indices[i]]

    return ns

def printnsmooth(p, start, end):
    print(f"The {p}-smooth numbers from index {start} to {end} are:")
    print(nsmooth(p, end)[start-1:])
    print()

def main():
    init()

    printnsmooth(2, 1, 25)
    for start, end in [[1, 25], [3000, 3002]]:
        for p in smallprimes[1:]:
            printnsmooth(p, start, end)

    for p in [503, 509, 521]:
        printnsmooth(p, 30000, 30019)

main()
