def optim4(a):
    global u
    n = len(a) - 1
    u = [None] * n
    u[0] = [[None, 0]] * n
    for j in range(1, n):
        v = [None] * (n - j)
        for i in range(n - j):
            m = None
            for k in range(j):
                s1, c1 = u[k][i]
                s2, c2 = u[j - k - 1][i + k + 1]
                c = c1 + c2 + a[i] * a[i + k + 1] * a[i + j + 1]
                if m is None or c < m:
                    s = k
                    m = c
            v[i] = [s, m]
        u[j] = v
    def aux(i, j):
        s, c = u[j][i]
        if s is None:
            return i
        else:
            return [aux(i, s), aux(i + s + 1, j - s - 1)]
    return u[n - 1][0][1], aux(0, n - 1)


print(optim4([1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2]))
print(optim4([1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10]))
