from prime_decomposition import decompose

def semiprime(n):
    d = decompose(n)
    try:
        return next(d) * next(d) == n
    except:
        return False
