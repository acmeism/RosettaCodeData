from __future__ import print_function

def lgen(even=False, nmax=1000000):
    start = 2 if even else 1
    n, lst = 1, list(range(start, nmax + 1, 2))
    lenlst = len(lst)
    yield lst[0]
    while n < lenlst and lst[n] < lenlst:
        yield lst[n]
        n, lst = n + 1, [j for i,j in enumerate(lst, 1) if i % lst[n]]
        lenlst = len(lst)
    # drain
    for i in lst[n:]:
        yield i
