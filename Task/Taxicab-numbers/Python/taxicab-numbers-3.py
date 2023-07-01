from heapq import heappush, heappop

def cubesum():
    h,n = [],1
    while True:
        while not h or h[0][0] > n**3: # could also pre-calculate cubes
            heappush(h, (n**3 + 1, n, 1))
            n += 1

        (s, x, y) = heappop(h)
        yield((s, x, y))
        y += 1
        if y < x:    # should be y <= x?
            heappush(h, (x**3 + y**3, x, y))

def taxis():
    out = [(0,0,0)]
    for s in cubesum():
        if s[0] == out[-1][0]:
            out.append(s)
        else:
            if len(out) > 1: yield(out)
            out = [s]

n = 0
for x in taxis():
    n += 1
    if n >= 2006: break
    if n <= 25 or n >= 2000:
        print(n, x)
