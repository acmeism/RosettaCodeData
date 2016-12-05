from functools import reduce
from operator import add

def rangeexpand(s):
    return reduce(add,
            map(lambda x: list(range(*map(int, x.split('-')))) if '-' in x else [int(x)], s.split(',')))
