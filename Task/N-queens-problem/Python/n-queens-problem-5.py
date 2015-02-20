def queens(n):
    a = list(range(n))
    up = [True]*(2*n - 1)
    down = [True]*(2*n - 1)
    def sub(i):
        nonlocal a, up, down
        for k in range(i, n):
            j = a[k]
            p = i + j
            q = i - j + n - 1
            if up[p] and down[q]:
                if i == n - 1:
                    yield tuple(a)
                else:
                    up[p] = down[q] = False
                    a[i], a[k] = a[k], a[i]
                    yield from sub(i + 1)
                    up[p] = down[q] = True
                    a[i], a[k] = a[k], a[i]
    yield from sub(0)
