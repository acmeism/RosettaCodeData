from sys import stdout
neighbours = [[-1, 0], [0, -1], [1, 0], [0, 1]]
exists = []
lastNumber = 0
wid = 0
hei = 0


def find_next(pa, x, y, z):
    for i in range(4):
        a = x + neighbours[i][0]
        b = y + neighbours[i][1]
        if wid > a > -1 and hei > b > -1:
            if pa[a][b] == z:
                return a, b

    return -1, -1


def find_solution(pa, x, y, z):
    if z > lastNumber:
        return 1
    if exists[z] == 1:
        s = find_next(pa, x, y, z)
        if s[0] < 0:
            return 0
        return find_solution(pa, s[0], s[1], z + 1)

    for i in range(4):
        a = x + neighbours[i][0]
        b = y + neighbours[i][1]
        if wid > a > -1 and hei > b > -1:
            if pa[a][b] == 0:
                pa[a][b] = z
                r = find_solution(pa, a, b, z + 1)
                if r == 1:
                    return 1
                pa[a][b] = 0

    return 0


def solve(pz, w, h):
    global lastNumber, wid, hei, exists

    lastNumber = w * h
    wid = w
    hei = h
    exists = [0 for j in range(lastNumber + 1)]

    pa = [[0 for j in range(h)] for i in range(w)]
    st = pz.split()
    idx = 0
    for j in range(h):
        for i in range(w):
            if st[idx] == ".":
                idx += 1
            else:
                pa[i][j] = int(st[idx])
                exists[pa[i][j]] = 1
                idx += 1

    x = 0
    y = 0
    t = w * h + 1
    for j in range(h):
        for i in range(w):
            if pa[i][j] != 0 and pa[i][j] < t:
                t = pa[i][j]
                x = i
                y = j

    return find_solution(pa, x, y, t + 1), pa


def show_result(r):
    if r[0] == 1:
        for j in range(hei):
            for i in range(wid):
                stdout.write(" {:0{}d}".format(r[1][i][j], 2))
            print()
    else:
        stdout.write("No Solution!\n")

    print()


r = solve(". . . . . . . . . . . 46 45 . 55 74 . . . 38 . . 43 . . 78 . . 35 . . . . . 71 . . . 33 . . . 59 . . . 17"
          " . . . . . 67 . . 18 . . 11 . . 64 . . . 24 21 . 1  2 . . . . . . . . . . .", 9, 9)
show_result(r)

r = solve(". . . . . . . . . . 11 12 15 18 21 62 61 . .  6 . . . . . 60 . . 33 . . . . . 57 . . 32 . . . . . 56 . . 37"
          " .  1 . . . 73 . . 38 . . . . . 72 . . 43 44 47 48 51 76 77 . . . . . . . . . .", 9, 9)
show_result(r)

r = solve("17 . . . 11 . . . 59 . 15 . . 6 . . 61 . . . 3 . . .  63 . . . . . . 66 . . . . 23 24 . 68 67 78 . 54 55"
          " . . . . 72 . . . . . . 35 . . . 49 . . . 29 . . 40 . . 47 . 31 . . . 39 . . . 45", 9, 9)
show_result(r)
