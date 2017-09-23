from sys import stdout

neighbours = [[2, 2], [-2, 2], [2, -2], [-2, -2], [3, 0], [0, 3], [-3, 0], [0, -3]]
cnt = 0
pWid = 0
pHei = 0


def is_valid(a, b):
    return -1 < a < pWid and -1 < b < pHei


def iterate(pa, x, y, v):
    if v > cnt:
        return 1

    for i in range(len(neighbours)):
        a = x + neighbours[i][0]
        b = y + neighbours[i][1]
        if is_valid(a, b) and pa[a][b] == 0:
            pa[a][b] = v
            r = iterate(pa, a, b, v + 1)
            if r == 1:
                return r
            pa[a][b] = 0
    return 0


def solve(pz, w, h):
    global cnt, pWid, pHei

    pa = [[-1 for j in range(h)] for i in range(w)]
    f = 0
    pWid = w
    pHei = h
    for j in range(h):
        for i in range(w):
            if pz[f] == "1":
                pa[i][j] = 0
                cnt += 1
            f += 1

    for y in range(h):
        for x in range(w):
            if pa[x][y] == 0:
                pa[x][y] = 1
                if 1 == iterate(pa, x, y, 2):
                    return 1, pa
                pa[x][y] = 0

    return 0, pa

r = solve("011011011111111111111011111000111000001000", 7, 6)
if r[0] == 1:
    for j in range(6):
        for i in range(7):
            if r[1][i][j] == -1:
                stdout.write("   ")
            else:
                stdout.write(" {:0{}d}".format(r[1][i][j], 2))
        print()
else:
    stdout.write("No solution!")
