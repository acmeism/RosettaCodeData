>>> def identity(size):
...     return {(x, y):int(x == y) for x in range(size) for y in range(size)}
...
>>> size = 4
>>> matrix = identity(size)
>>> print('\n'.join(' '.join(str(matrix[(x, y)]) for x in range(size)) for y in range(size)))
1 0 0 0
0 1 0 0
0 0 1 0
0 0 0 1
>>>
