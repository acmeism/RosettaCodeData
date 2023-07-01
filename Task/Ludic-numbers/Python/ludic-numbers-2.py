def ludic(nmax=64):
    yield 1
    taken = []
    while True:
        lst, nmax = list(range(2, nmax + 1)), nmax * 2
        for t in taken:
            del lst[::t]
        while lst:
            t = lst[0]
            taken.append(t)
            yield t
            del lst[::t]
