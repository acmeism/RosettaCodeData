from itertools import imap

f = lambda x, y, z: x + max(y, z)
g = lambda xs, ys: list(imap(f, ys, xs, xs[1:]))
data = [map(int, row.split()) for row in open("triangle.txt")][::-1]
print reduce(g, data)[0]
