from itertools import islice, tee

def klarner_rado():
    def gen():
        m2 = m3 = 1
        while True:
            m = min(m2, m3)
            yield m
            if m2 == m: m2 = next(g2) << 1 | 1
            if m3 == m: m3 = next(g3) * 3 + 1
    g, g2, g3 = tee(gen(), 3)
    return g

kr = klarner_rado()
print(*islice(kr, 100))
for n in 900, 9000, 90000, 900000, 9000000:
    print(*islice(kr, n - 1, n))
