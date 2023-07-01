from sys import stdout
moves = [
    [-1, -2], [1, -2], [-1, 2], [1, 2],
    [-2, -1], [-2, 1], [2, -1], [2, 1]
]


def solve(pz, sz, sx, sy, idx, cnt):
    if idx > cnt:
        return 1

    for i in range(len(moves)):
        x = sx + moves[i][0]
        y = sy + moves[i][1]
        if sz > x > -1 and sz > y > -1 and pz[x][y] == 0:
            pz[x][y] = idx
            if 1 == solve(pz, sz, x, y, idx + 1, cnt):
                return 1
            pz[x][y] = 0

    return 0


def find_solution(pz, sz):
    p = [[-1 for j in range(sz)] for i in range(sz)]
    idx = x = y = cnt = 0
    for j in range(sz):
        for i in range(sz):
            if pz[idx] == "x":
                p[i][j] = 0
                cnt += 1
            elif pz[idx] == "s":
                p[i][j] = 1
                cnt += 1
                x = i
                y = j
            idx += 1

    if 1 == solve(p, sz, x, y, 2, cnt):
        for j in range(sz):
            for i in range(sz):
                if p[i][j] != -1:
                    stdout.write(" {:0{}d}".format(p[i][j], 2))
                else:
                    stdout.write("   ")
            print()
    else:
        print("Cannot solve this puzzle!")


# entry point
find_solution(".xxx.....x.xx....xxxxxxxxxx..x.xx.x..xxxsxxxxxx...xx.x.....xxx..", 8)
print()
find_solution(".....s.x..........x.x.........xxxxx.........xxx.......x..x.x..x..xxxxx...xxxxx..xx.....xx..xxxxx...xxxxx..x..x.x..x.......xxx.........xxxxx.........x.x..........x.x.....", 13)
