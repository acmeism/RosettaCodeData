from operator import le
from random import shuffle
from itertools import dropwhile, islice, repeat, starmap

def shuffled(x):
    x = x[:]
    shuffle(x)
    return x

bogosort = lambda l: next(dropwhile(
    lambda l: not all(starmap(le, zip(l, islice(l, 1, None)))),
    map(shuffled, repeat(l))))
