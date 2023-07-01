from prime_decomposition import decompose
from itertools import islice, count
try:
    from functools import reduce
except:
    pass


def almostprime(n, k=2):
    d = decompose(n)
    try:
        terms = [next(d) for i in range(k)]
        return reduce(int.__mul__, terms, 1) == n
    except:
        return False

if __name__ == '__main__':
    for k in range(1,6):
        print('%i: %r' % (k, list(islice((n for n in count() if almostprime(n, k)), 10))))
