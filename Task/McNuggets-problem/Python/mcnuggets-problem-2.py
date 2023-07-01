>>> from itertools import product
>>> max(x for x in range(100+1) if x not in
...   (6*s + 9*n + 20*t for s, n, t in
...     product(range(100//6+1), range(100//9+1), range(100//20+1))))
43
>>>
