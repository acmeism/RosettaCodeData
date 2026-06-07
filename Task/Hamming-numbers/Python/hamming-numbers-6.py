from itertools import islice, chain, tee

def merge(r, s):
    # This is faster than heapq.merge.
    rr = next(r)
    ss = next(s)
    while True:
        if rr < ss:
            yield rr
            rr = next(r)
        else:
            yield ss
            ss = next(s)

def p(n):
    def gen():
        x = n
        while True:
            yield x
            x *= n
    return gen()

def pp(n, s):
    def gen():
        for x in (merge(s, chain([n], (n * y for y in fb)))):
            yield x
    r, fb = tee(gen())
    return r

def hamming(a, b = None):
    if not b:
        b = a + 1
    seq = (chain([1], pp(5, pp(3, p(2)))))
    return list(islice(seq, a - 1, b - 1))

print(hamming(1, 21))
print(hamming(1691)[0])
print(hamming(1000000)[0])
