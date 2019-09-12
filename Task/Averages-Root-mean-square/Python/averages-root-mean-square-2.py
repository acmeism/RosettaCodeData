from functools import (reduce)
from math import (sqrt)


# rootMeanSquare :: [Num] -> Float
def rootMeanSquare(xs):
    return sqrt(reduce(lambda a, x: a + x * x, xs, 0) / len(xs))


print(
    rootMeanSquare([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
)
