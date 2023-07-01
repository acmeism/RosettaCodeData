def factorize(n):
    assert(isinstance(n, int))
    if n < 0:
        n = -n
    if n < 2:
        return
    k = 0
    while 0 == n%2:
        k += 1
        n //= 2
    if 0 < k:
        yield (2,k)
    p = 3
    while p*p <= n:
        k = 0
        while 0 == n%p:
            k += 1
            n //= p
        if 0 < k:
            yield (p,k)
        p += 2
    if 1 < n:
        yield (n,1)

def tau(n):
    assert(n != 0)
    ans = 1
    for (p,k) in factorize(n):
        ans *= 1 + k
    return ans

if __name__ == "__main__":
    print(*map(tau, range(1, 101)))
