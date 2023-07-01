from itertools import islice, count
import matplotlib.pyplot as plt
import heapq

def twosquares():
    q, n = [], 1

    while True:
        while not q or n*n <= q[0][0]:
            heapq.heappush(q, (n*n, n, 0))
            n += 1

        s, xy = q[0][0], []

        while q and q[0][0] == s: # pop all vectors with same length
            s, a, b = heapq.heappop(q)
            xy.append((a, b))
            if a > b:
                heapq.heappush(q, (a*a + (b+1)*(b+1), a, b + 1))

        yield tuple(xy)

def gen_dirs():
    d = (0, 1)
    for v in twosquares():
        # include symmetric vectors
        v += tuple((b, a) for a, b in v if a != b)
        v += tuple((a, -b) for a, b in v if b)
        v += tuple((-a, b) for a, b in v if a)

        # filter using dot and cross product
        d = max((a*d[0] + b*d[1], a, b) for a, b in v if a*d[1] - b*d[0] >= 0)[1:]
        yield d

def positions():
    p = (0, 0)
    for d in gen_dirs():
        yield p
        p = (p[0] + d[0], p[1] + d[1])

print(list(islice(positions(), 40)))

plt.plot(*zip(*list(islice(positions(), 100000))), lw=0.4)
plt.gca().set_aspect(1)
plt.show()
