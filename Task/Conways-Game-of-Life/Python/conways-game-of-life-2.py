from collections import defaultdict

glider = [(1, 0), (2, 1), (0, 2), (1, 2), (2, 2)]
blinker = [(1, 0), (1, 1), (1, 2)]

def neighbors(cell):
    x,y = cell
    r = range(-1,2)
    return [(x+dx, y+dy) for dx in r for dy in r if not (dx, dy) == (0, 0)]

def frequencies(cells):
    res = defaultdict(int)
    for cell in cells:
        res[cell] += 1
    return res

def lifeStep(cells):
    freqs = frequencies(n for c in cells for n in neighbors(c))
    return [k for k in freqs if freqs[k]==3 or (freqs[k]==2 and k in cells)]

def printWorld(cells, worldSize=10):
    for y in range(0, worldSize):
        print ["#" if (x, y) in cells else "." for x in range(0, worldSize)]

def runLife(worldSize, steps, cells):
    printWorld(cells, worldSize)
    print ""
    if 0 < steps:
        runLife(worldSize, steps-1, lifeStep(cells))
