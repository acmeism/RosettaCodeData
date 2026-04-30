from math import floor
from math import sqrt

def non_square(n):
    return n + floor(0.5 + sqrt(n))

first_22 = [non_square(i) for i in range(1, 23)]
print(first_22)

first_million = (non_square(i) for i in range(1, 10**6))
assert not any(sqrt(i).is_integer() for i in first_million)
