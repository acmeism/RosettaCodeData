def queens_lex(n: int):

    def sub(i: int):
        if i < n:
            for k in range(i, n):
                j = a[k]
                a[i], a[k] = a[k], a[i]
                if b[i + j] and c[i - j]:
                    b[i + j] = c[i - j] = False
                    yield from sub(i + 1)
                    b[i + j] = c[i - j] = True
            a[i:(n - 1)], a[n - 1] = a[(i + 1):n], a[i]
        else:
            yield a

    a = list(range(n))
    b = [True] * (2 * n - 1)
    c = [True] * (2 * n - 1)
    yield from sub(0)


next(queens(31))
[0, 2, 4, 1, 3, 8, 10, 12, 14, 6, 17, 21, 26, 28, 25, 27, 24, 30, 7, 5, 29, 15, 13, 11, 9, 18, 22, 19, 23, 16, 20]

next(queens_lex(31))
[0, 2, 4, 1, 3, 8, 10, 12, 14, 5, 17, 22, 25, 27, 30, 24, 26, 29, 6, 16, 28, 13, 9, 7, 19, 11, 15, 18, 21, 23, 20]

#Compare to A065188
#1, 3, 5, 2, 4, 9, 11, 13, 15, 6, 8, 19, 7, 22, 10, 25, 27, 29, 31, 12, 14, 35, 37, ...
