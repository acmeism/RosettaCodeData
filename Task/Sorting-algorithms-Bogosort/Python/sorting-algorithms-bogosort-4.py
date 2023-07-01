import operator
import random
from itertools import dropwhile, imap, islice, izip, repeat, starmap

def shuffled(x):
    x = x[:]
    random.shuffle(x)
    return x

bogosort = lambda l: next(dropwhile(
    lambda l: not all(starmap(operator.le, izip(l, islice(l, 1, None)))),
    imap(shuffled, repeat(l))))
