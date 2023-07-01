try:
    import psyco
    psyco.full()
except ImportError:
    pass

best = [0] * 16

def try_swaps(deck, f, s, d, n):
    if d > best[n]:
        best[n] = d

    i = 0
    k = 1 << s
    while s:
        k >>= 1
        s -= 1
        if deck[s] == -1 or deck[s] == s:
            break
        i |= k
        if (i & f) == i and d + best[s] <= best[n]:
            return d
    s += 1

    deck2 = list(deck)
    k = 1
    for i2 in xrange(1, s):
        k <<= 1
        if deck2[i2] == -1:
            if f & k: continue
        elif deck2[i2] != i2:
            continue

        deck[i2] = i2
        deck2[:i2 + 1] = reversed(deck[:i2 + 1])
        try_swaps(deck2, f | k, s, 1 + d, n)

def topswops(n):
    best[n] = 0
    deck0 = [-1] * 16
    deck0[0] = 0
    try_swaps(deck0, 1, n, 0, n)
    return best[n]

for i in xrange(1, 13):
    print "%2d: %d" % (i, topswops(i))
