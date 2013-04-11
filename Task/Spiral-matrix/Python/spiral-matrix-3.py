def spiral(n):
    dat = [[None] * n for i in range(n)]
    le = [[i + 1, i + 1] for i in reversed(range(n))]
    le = sum(le, [])[1:]  # for n = 5 le will be [5, 4, 4, 3, 3, 2, 2, 1, 1]
    dxdy = [[1, 0], [0, 1], [-1, 0], [0, -1]] * ((len(le) + 4) / 4)  # long enough
    x, y, val = -1, 0, -1
    for steps, (dx, dy) in zip(le, dxdy):
        x, y, val = x + dx, y + dy, val + 1
        for j in range(steps):
            dat[y][x] = val
            if j != steps-1:
                x, y, val = x + dx, y + dy, val + 1
    return dat

for row in spiral(5): # calc spiral and print it
    print ' '.join('%3s' % x for x in row)
