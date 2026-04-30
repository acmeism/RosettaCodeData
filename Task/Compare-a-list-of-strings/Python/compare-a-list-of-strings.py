import operator
from itertools import pairwise
from itertools import starmap

strings = ["a", "b", "c", "d", "e", "f"]

"""Test that all items in `strings` are equal."""

# A generator expression with zip and a slice. Creates a copy of `strings` - 1.
all(a == b for a, b in zip(strings, strings[1:]))

# A set. Creates a new set containing items in `strings`.
len(set(strings)) == 1

# map and a slice. Creates a copy of `strings` -1.
all(map(operator.eq, strings, strings[1:]))

# starmap and pairwise. Requires Python 3.10+.
all(starmap(operator.eq, pairwise(strings)))


# An explicit loop with early return. Requires Python 3.10+.
def all_equal(strings: list[str]) -> bool:
    for a, b in pairwise(strings):
        if a != b:
            return False
    return True


"""Test that items in `strings` are in strictly ascending order."""

# A generator expression with zip and a slice. Creates a copy of `strings` - 1.
all(a < b for a, b in zip(strings, strings[1:]))

# map and a slice. Creates a copy of `strings` -1.
all(map(operator.lt, strings, strings[1:]))

# starmap and pairwise. Requires Python 3.10+.
all(starmap(operator.lt, pairwise(strings)))


# An explicit loop with early return. Requires Python 3.10+.
def strictly_ascending(strings: list[str]) -> bool:
    for a, b in pairwise(strings):
        if a >= b:
            return False
    return True
