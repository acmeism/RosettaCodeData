""" Rosetta Code task rosettacode.org/wiki/Babylonian_spiral """

from itertools import accumulate
from math import isqrt, atan2, tau
from matplotlib.pyplot import axis, plot, show


square_cache = []

def babylonian_spiral(nsteps):
    """
    Get the points for each step along a Babylonia spiral of `nsteps` steps.
    Origin is at (0, 0) with first step one unit in the positive direction along
    the vertical (y) axis. The other points are selected to have integer x and y
    coordinates, progressively concatenating the next longest vector with integer
    x and y coordinates on the grid. The direction change of the  new vector is
    chosen to be nonzero and clockwise in a direction that minimizes the change
    in direction from the previous vector.

    See also: oeis.org/A256111, oeis.org/A297346, oeis.org/A297347
    """
    if len(square_cache) <= nsteps:
        square_cache.extend([x * x for x in range(len(square_cache), nsteps)])
    xydeltas = [(0, 0), (0, 1)]
    δsquared = 1
    for _ in range(nsteps - 2):
        x, y = xydeltas[-1]
        θ = atan2(y, x)
        candidates = []
        while not candidates:
            δsquared += 1
            for i, a in enumerate(square_cache):
                if a > δsquared // 2:
                    break
                for j in range(isqrt(δsquared) + 1, 0, -1):
                    b = square_cache[j]
                    if a + b < δsquared:
                        break
                    if a + b == δsquared:
                        candidates.extend([(i, j), (-i, j), (i, -j), (-i, -j), (j, i), (-j, i),
                           (j, -i), (-j, -i)])

        p = min(candidates, key=lambda d: (θ - atan2(d[1], d[0])) % tau)
        xydeltas.append(p)

    return list(accumulate(xydeltas, lambda a, b: (a[0] + b[0], a[1] + b[1])))


points10000 = babylonian_spiral(10000)
print("The first 40 Babylonian spiral points are:")
for i, p in enumerate(points10000[:40]):
     print(str(p).ljust(10), end = '\n' if (i + 1) % 10 == 0 else '')

# stretch portion of task
plot(*zip(*points10000), color="navy", linewidth=0.2)
axis('scaled')
show()
