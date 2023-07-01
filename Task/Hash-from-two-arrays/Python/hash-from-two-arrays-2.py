keys = ['a', 'b', 'c']
values = [1, 2, 3]
hash = dict(zip(keys, values))

# Lazily, Python 2.3+, not 3.x:
from itertools import izip
hash = dict(izip(keys, values))
