# pylint: disable=invalid-name
# pylint: disable=unused-argument
"ZigZag iterator."
import sys

if sys.version_info[0] >= 3:
    xrange = range

def move(x, y, columns, rows):
    "Tells us what to do next with x and y."
    if y < (rows - 1):
        return max(0, x-1), y+1
    return x+1, y

def zigzag(rows, columns):
    "ZigZag iterator, yields indices."
    x, y = 0, 0
    size = rows * columns
    for _ in xrange(size):
        yield y, x
        if (x + y) & 1:
            x, y = move(x, y, columns, rows)
        else:
            y, x = move(y, x, rows, columns)

# test code
i, rows, cols = 0, 5, 5
mat = [[0 for x in range(cols)] for y in range(rows)]
for (y, x) in zigzag(rows, cols):
    mat[y][x], i = i, i + 1

from pprint import pprint
pprint(mat)
