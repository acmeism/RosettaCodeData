from itertools import product, combinations, izip

scoring = [0, 1, 3]
histo = [[0] * 10 for _ in xrange(4)]

for results in product(range(3), repeat=6):
    s = [0] * 4
    for r, g in izip(results, combinations(range(4), 2)):
        s[g[0]] += scoring[r]
        s[g[1]] += scoring[2 - r]

    for h, v in izip(histo, sorted(s)):
        h[v] += 1

for x in reversed(histo):
    print x
