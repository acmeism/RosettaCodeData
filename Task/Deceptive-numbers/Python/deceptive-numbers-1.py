from itertools import count, islice
from math import isqrt

def is_deceptive(n):
    if n & 1 and n % 3 and n % 5 and pow(10, n - 1, n) == 1:
        for d in range(7, isqrt(n) + 1, 6):
            if not (n % d and n % (d + 4)): return True
    return False

print(*islice(filter(is_deceptive, count(49)), 100))
