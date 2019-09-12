from itertools import (accumulate, chain)
from operator import mul


# factorials :: [Integer]
def factorials(n):
    return list(
        accumulate(chain([1], range(1, 1 + n)), mul)
    )

print(factorials(5))

# -> [1, 1, 2, 6, 24, 120]
