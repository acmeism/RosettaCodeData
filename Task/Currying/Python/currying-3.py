>>> from functools import partial
>>> from operator import add
>>> add2 = partial(add, 2)
>>> add2
functools.partial(<built-in function add>, 2)
>>> add2(7)
9
>>> double = partial(map, lambda x: x*2)
>>> print(*double(range(5)))
0 2 4 6 8
