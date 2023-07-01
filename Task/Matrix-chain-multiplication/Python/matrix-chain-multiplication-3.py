def optim1(a):
    def cost(k):
        if type(k) is int:
            return 0, a[k], a[k + 1]
        else:
            s1, p1, q1 = cost(k[0])
            s2, p2, q2 = cost(k[1])
            assert q1 == p2
            return s1 + s2 + p1 * q1 * q2, p1, q2
    cmin = None
    n = len(a) - 1
    for u in parens(n):
        c, p, q = cost(u)
        if cmin is None or c < cmin:
            cmin = c
            umin = u
    return cmin, umin
