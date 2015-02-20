from collections import Counter

def life(world, N):
    "Play Conway's game of life for N generations from initial world."
    for g in range(N+1):
        display(world, g)
        counts = Counter(n for c in world for n in offset(neighboring_cells, c))
        world = {c for c in counts
                if counts[c] == 3 or (counts[c] == 2 and c in world)}

neighboring_cells = [(-1, -1), (-1, 0), (-1, 1),
                     ( 0, -1),          ( 0, 1),
                     ( 1, -1), ( 1, 0), ( 1, 1)]

def offset(cells, delta):
    "Slide/offset all the cells by delta, a (dx, dy) vector."
    (dx, dy) = delta
    return {(x+dx, y+dy) for (x, y) in cells}

def display(world, g):
    "Display the world as a grid of characters."
    print '          GENERATION {}:'.format(g)
    Xs, Ys = zip(*world)
    Xrange = range(min(Xs), max(Xs)+1)
    for y in range(min(Ys), max(Ys)+1):
        print ''.join('#' if (x, y) in world else '.'
                      for x in Xrange)

blinker = {(1, 0), (1, 1), (1, 2)}
block   = {(0, 0), (1, 1), (0, 1), (1, 0)}
toad    = {(1, 2), (0, 1), (0, 0), (0, 2), (1, 3), (1, 1)}
glider  = {(0, 1), (1, 0), (0, 0), (0, 2), (2, 1)}
world   = (block | offset(blinker, (5, 2)) | offset(glider, (15, 5)) | offset(toad, (25, 5))
           | {(18, 2), (19, 2), (20, 2), (21, 2)} | offset(block, (35, 7)))


life(world, 5)
