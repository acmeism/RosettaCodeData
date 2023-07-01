def optim2(a):
    def aux(n, k):
        if n == 1:
            p, q = a[k:k + 2]
            return 0, p, q, k
        elif n == 2:
            p, q, r = a[k:k + 3]
            return p * q * r, p, r, [k, k + 1]
        else:
            m = None
            p = a[k]
            q = a[k + n]
            for i in range(1, n):
                s1, p1, q1, u1 = aux(i, k)
                s2, p2, q2, u2 = aux(n - i, k + i)
                assert q1 == p2
                s = s1 + s2 + p1 * q1 * q2
                if m is None or s < m:
                    m = s
                    u = [u1, u2]
            return m, p, q, u
    s, p, q, u = aux(len(a) - 1, 0)
    return s, u
