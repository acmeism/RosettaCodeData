try:
    import psyco
except ImportError:
    pass
else:
    psyco.full()

w, h = 0, 0
count = 0
vis = []

def cwalk(y, x, d):
    global vis, count, w, h
    if not y or y == h or not x or x == w:
        count += 1
        return

    vis[y][x] = vis[h - y][w - x] = 1

    if x and not vis[y][x - 1]:
        cwalk(y, x - 1, d | 1)
    if (d & 1) and x < w and not vis[y][x+1]:
        cwalk(y, x + 1, d|1)
    if y and not vis[y - 1][x]:
        cwalk(y - 1, x, d | 2)
    if (d & 2) and y < h and not vis[y + 1][x]:
        cwalk(y + 1, x, d | 2)

    vis[y][x] = vis[h - y][w - x] = 0

def count_only(x, y):
    global vis, count, w, h
    count = 0
    w = x
    h = y

    if (h * w) & 1:
        return count
    if h & 1:
        w, h = h, w

    vis = [[0] * (w + 1) for _ in xrange(h + 1)]
    vis[h // 2][w // 2] = 1

    if w & 1:
        vis[h // 2][w // 2 + 1] = 1

    res = 0
    if w > 1:
        cwalk(h // 2, w // 2 - 1, 1)
        res = 2 * count - 1
        count = 0
        if w != h:
            cwalk(h // 2 + 1, w // 2, 3 if (w & 1) else 2)

        res += 2 * count - (not (w & 1))
    else:
        res = 1

    if w == h:
        res = 2 * res + 2
    return res

def main():
    for y in xrange(1, 10):
        for x in xrange(1, y + 1):
            if not (x & 1) or not (y & 1):
                print "%d x %d: %d" % (y, x, count_only(x, y))

main()
