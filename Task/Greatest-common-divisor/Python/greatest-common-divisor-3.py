def gcd_iter(u, v):
    while v:
        u, v = v, u % v
    return abs(u)
