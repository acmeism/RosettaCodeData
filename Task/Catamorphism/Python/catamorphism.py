from functools import reduce
from operator import add
from operator import mul

def concat(a: int | str, b: int | str) -> str:
    return str(a) + str(b)

a = list(range(1, 11))

print(a)
print(f"sum: {reduce(add, a)}")
print(f"product: {reduce(mul, a)}")
print(f"concat: {reduce(concat, a)}")
