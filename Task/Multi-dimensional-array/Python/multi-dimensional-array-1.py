>>> from pprint import pprint as pp   # Pretty printer
>>> from itertools import product
>>>
>>> def dict_as_mdarray(dimensions=(2, 3), init=0.0):
...     return {indices: init for indices in product(*(range(i) for i in dimensions))}
...
>>>
>>> mdarray = dict_as_mdarray((2, 3, 4, 5))
>>> pp(mdarray)
{(0, 0, 0, 0): 0.0,
 (0, 0, 0, 1): 0.0,
 (0, 0, 0, 2): 0.0,
 (0, 0, 0, 3): 0.0,
 (0, 0, 0, 4): 0.0,
 (0, 0, 1, 0): 0.0,
...
 (1, 2, 3, 0): 0.0,
 (1, 2, 3, 1): 0.0,
 (1, 2, 3, 2): 0.0,
 (1, 2, 3, 3): 0.0,
 (1, 2, 3, 4): 0.0}
>>> mdarray[(0, 1, 2, 3)]
0.0
>>> mdarray[(0, 1, 2, 3)] = 6.78
>>> mdarray[(0, 1, 2, 3)]
6.78
>>> mdarray[(0, 1, 2, 3)] = 5.4321
>>> mdarray[(0, 1, 2, 3)]
5.4321
>>> pp(mdarray)
{(0, 0, 0, 0): 0.0,
 (0, 0, 0, 1): 0.0,
 (0, 0, 0, 2): 0.0,
...
 (0, 1, 2, 2): 0.0,
 (0, 1, 2, 3): 5.4321,
 (0, 1, 2, 4): 0.0,
...
 (1, 2, 3, 3): 0.0,
 (1, 2, 3, 4): 0.0}
>>>
