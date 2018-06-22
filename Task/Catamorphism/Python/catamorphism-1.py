>>> # Python 2.X
>>> from operator import add
>>> listoflists = [['the', 'cat'], ['sat', 'on'], ['the', 'mat']]
>>> help(reduce)
Help on built-in function reduce in module __builtin__:

reduce(...)
    reduce(function, sequence[, initial]) -> value

    Apply a function of two arguments cumulatively to the items of a sequence,
    from left to right, so as to reduce the sequence to a single value.
    For example, reduce(lambda x, y: x+y, [1, 2, 3, 4, 5]) calculates
    ((((1+2)+3)+4)+5).  If initial is present, it is placed before the items
    of the sequence in the calculation, and serves as a default when the
    sequence is empty.

>>> reduce(add, listoflists, [])
['the', 'cat', 'sat', 'on', 'the', 'mat']
>>>
