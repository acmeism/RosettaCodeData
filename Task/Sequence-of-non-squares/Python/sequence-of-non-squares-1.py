>>> from math import floor, sqrt
>>> def non_square(n):
        return n + floor(1/2 + sqrt(n))

>>> # first 22 values has no squares:
>>> print(*map(non_square, range(1, 23)))
2 3 5 6 7 8 10 11 12 13 14 15 17 18 19 20 21 22 23 24 26 27

>>> # The following check shows no squares up to one million:
>>> def is_square(n):
        return sqrt(n).is_integer()

>>> non_squares = map(non_square, range(1, 10 ** 6))
>>> next(filter(is_square, non_squares))
StopIteration                             Traceback (most recent call last)
<ipython-input-45-f32645fc1c0a> in <module>()
      1 non_squares = map(non_square, range(1, 10 ** 6))
----> 2 next(filter(is_square, non_squares))

StopIteration:
