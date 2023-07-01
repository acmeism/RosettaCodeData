def tau(n):
    assert(isinstance(n, int) and 0 < n)
    t = (n - 1 ^ n).bit_length()
    n >>= t - 1
    p = 3
    while p * p <= n:
        a = t
        while n % p == 0:
            t += a
            n //= p
        p += 2
    if n != 1:
        t += t
    return t

if __name__ == "__main__":
    print(*map(tau, range(1, 101)))
