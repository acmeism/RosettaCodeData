def queens_lex(n):
    a = list(range(n))
    up = [True]*(2*n - 1)
    down = [True]*(2*n - 1)
    def sub(i):
        if i == n:
            yield tuple(a)
        else:
            for k in range(i, n):
                a[i], a[k] = a[k], a[i]
                j = a[i]
                p = i + j
                q = i - j + n - 1
                if up[p] and down[q]:
                    up[p] = down[q] = False
                    yield from sub(i + 1)
                    up[p] = down[q] = True
            x = a[i]
            for k in range(i + 1, n):
                a[k - 1] = a[k]
            a[n - 1] = x
    yield from sub(0)

next(queens(31))
(0, 2, 4, 1, 3, 8, 10, 12, 14, 6, 17, 21, 26, 28, 25, 27, 24, 30, 7, 5, 29, 15, 13, 11, 9, 18, 22, 19, 23, 16, 20)

next(queens_lex(31))
(0, 2, 4, 1, 3, 8, 10, 12, 14, 5, 17, 22, 25, 27, 30, 24, 26, 29, 6, 16, 28, 13, 9, 7, 19, 11, 15, 18, 21, 23, 20)

#Compare to A065188
#1, 3, 5, 2, 4, 9, 11, 13, 15, 6, 8, 19, 7, 22, 10, 25, 27, 29, 31, 12, 14, 35, 37, ...
