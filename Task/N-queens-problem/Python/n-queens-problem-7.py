def queens(n):
    a = list(range(n))
    up = [True]*(2*n - 1)
    down = [True]*(2*n - 1)
    def sub(i):
        if i == n:
            yield tuple(a)
        else:
            for k in range(i, n):
                j = a[k]
                p = i + j
                q = i - j + n - 1
                if up[p] and down[q]:
                    up[p] = down[q] = False
                    a[i], a[k] = a[k], a[i]
                    yield from sub(i + 1)
                    up[p] = down[q] = True
                    a[i], a[k] = a[k], a[i]
    yield from sub(0)

#Count solutions for n=8:
sum(1 for p in queens(8))
92
