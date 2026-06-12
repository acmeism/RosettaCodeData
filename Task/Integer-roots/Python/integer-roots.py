def root(a, b):
    if b < 2:
        return b
    a1 = a - 1
    c = 1
    d = (a1 * c + b // (c ** a1)) // a
    e = (a1 * d + b // (d ** a1)) // a
    while c not in (d, e):
        c, d, e = d, e, (a1 * e + b // (e ** a1)) // a
    return min(d, e)


print("First 2,001 digits of the square root of two:\n{}".format(
    root(2, 2 * 100 ** 2000)
))
