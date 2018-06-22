# Python 3.X

from functools import reduce
from operator import add, mul

nums = range(1,11)

summation = reduce(add, nums)

product = reduce(mul, nums)

concatenation = reduce(lambda a, b: str(a) + str(b), nums)

print(summation, product, concatenation)
