from itertools import tee, chain, groupby, islice
from heapq import merge

def raymonds_hamming():
    # Generate "5-smooth" numbers, also called "Hamming numbers"
    # or "Regular numbers".  See: http://en.wikipedia.org/wiki/Regular_number
    # Finds solutions to 2**i * 3**j * 5**k  for some integers i, j, and k.

    def deferred_output():
        for i in output:
            yield i

    result, p2, p3, p5 = tee(deferred_output(), 4)
    m2 = (2*x for x in p2)                          # multiples of 2
    m3 = (3*x for x in p3)                          # multiples of 3
    m5 = (5*x for x in p5)                          # multiples of 5
    merged = merge(m2, m3, m5)
    combined = chain([1], merged)                   # prepend a starting point
    output = (k for k,g in groupby(combined))       # eliminate duplicates

    return result

print list(islice(raymonds_hamming(), 20))
print islice(raymonds_hamming(), 1689, 1690).next()
print islice(raymonds_hamming(), 999999, 1000000).next()
