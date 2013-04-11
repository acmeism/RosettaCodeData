def zigzag(n):
    def move(i, j):
        if j < (n - 1):
            return max(0, i-1), j+1
        else:
            return i+1, j
    a = [[0] * n for _ in xrange(n)]
    x, y = 0, 0
    for v in xrange(n * n):
        a[y][x] = v
        if (x + y) & 1:
            x, y = move(x, y)
        else:
            y, x = move(y, x)
    return a

from pprint import pprint
pprint(zigzag(5))
