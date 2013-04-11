import psyco

def hamming(limit):
    h = [1] * limit
    x2, x3, x5 = 2, 3, 5
    i = j = k = 0

    for n in xrange(1, limit):
        h[n] = min(x2, x3, x5)
        if x2 == h[n]:
            i += 1
            x2 = 2 * h[i]
        if x3 == h[n]:
            j += 1
            x3 = 3 * h[j]
        if x5 == h[n]:
            k += 1
            x5 = 5 * h[k]

    return h[-1]

psyco.bind(hamming)
print [hamming(i) for i in xrange(1, 21)]
print hamming(1691)
print hamming(1000000)
