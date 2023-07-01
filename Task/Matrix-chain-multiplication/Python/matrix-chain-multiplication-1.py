def parens(n):
    def aux(n, k):
        if n == 1:
            yield k
        elif n == 2:
            yield [k, k + 1]
        else:
            a = []
            for i in range(1, n):
                for u in aux(i, k):
                    for v in aux(n - i, k + i):
                        yield [u, v]
    yield from aux(n, 0)
