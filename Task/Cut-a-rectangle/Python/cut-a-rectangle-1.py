def cut_it(h, w):
    dirs = ((1, 0), (-1, 0), (0, -1), (0, 1))
    if h & 1: h, w = w, h
    if h & 1: return 0
    if w == 1: return 1
    count = 0

    next = [w + 1, -w - 1, -1, 1]
    blen = (h + 1) * (w + 1) - 1
    grid = [False] * (blen + 1)

    def walk(y, x, count):
        if not y or y == h or not x or x == w:
            return count + 1

        t = y * (w + 1) + x
        grid[t] = grid[blen - t] = True

        if not grid[t + next[0]]:
            count = walk(y + dirs[0][0], x + dirs[0][1], count)
        if not grid[t + next[1]]:
            count = walk(y + dirs[1][0], x + dirs[1][1], count)
        if not grid[t + next[2]]:
            count = walk(y + dirs[2][0], x + dirs[2][1], count)
        if not grid[t + next[3]]:
            count = walk(y + dirs[3][0], x + dirs[3][1], count)

        grid[t] = grid[blen - t] = False
        return count

    t = h // 2 * (w + 1) + w // 2
    if w & 1:
        grid[t] = grid[t + 1] = True
        count = walk(h // 2, w // 2 - 1, count)
        res = count
        count = 0
        count = walk(h // 2 - 1, w // 2, count)
        return res + count * 2
    else:
        grid[t] = True
        count = walk(h // 2, w // 2 - 1, count)
        if h == w:
            return count * 2
        count = walk(h // 2 - 1, w // 2, count)
        return count

def main():
    for w in xrange(1, 10):
        for h in xrange(1, w + 1):
            if not((w * h) & 1):
                print "%d x %d: %d" % (w, h, cut_it(w, h))

main()
