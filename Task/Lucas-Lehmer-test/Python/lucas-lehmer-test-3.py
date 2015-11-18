import gmpy2 as mp

def lucas_lehmer(n):
    if n == 2:
        return True
    if not mp.is_prime(n):
        return False
    two = mp.mpz(2)
    m = two**n - 1
    s = two*two
    for i in range(2, n):
        sqr = s*s
        s = (sqr & m) + (sqr >> n)
        if s >= m:
            s -= m
        s -= two
    return mp.is_zero(s)
