def queens(n: int):

    def sub(i: int):
        if i < n:
            for k in range(i, n):
                j = a[k]
                if b[i + j] and c[i - j]:
                    a[i], a[k] = a[k], a[i]
                    b[i + j] = c[i - j] = False
                    yield from sub(i + 1)
                    b[i + j] = c[i - j] = True
                    a[i], a[k] = a[k], a[i]
        else:
            yield a

    a = list(range(n))
    b = [True] * (2 * n - 1)
    c = [True] * (2 * n - 1)
    yield from sub(0)


sum(1 for p in queens(8))  # count solutions
92
