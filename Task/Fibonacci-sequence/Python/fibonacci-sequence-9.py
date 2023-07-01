def prevPowTwo(n):
    'Gets the power of two that is less than or equal to the given input'
    if ((n & -n) == n):
        return n
    else:
        n -= 1
        n |= n >> 1
        n |= n >> 2
        n |= n >> 4
        n |= n >> 8
        n |= n >> 16
        n += 1
        return (n/2)

def crazyFib(n):
    'Crazy fast fibonacci number calculation'
    powTwo = prevPowTwo(n)

    q = r = i = 1
    s = 0

    while(i < powTwo):
        i *= 2
        q, r, s = q*q + r*r, r * (q + s), (r*r + s*s)

    while(i < n):
        i += 1
        q, r, s = q+r, q, r

    return q
