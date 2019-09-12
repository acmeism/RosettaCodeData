def gcd(u, v):
    return gcd(v, u % v) if v else abs(u)
