>>> def is_odd(i): return bool(i & 1)

>>> def is_even(i): return not is_odd(i)

>>> [(j, is_odd(j)) for j in range(10)]
[(0, False), (1, True), (2, False), (3, True), (4, False), (5, True), (6, False), (7, True), (8, False), (9, True)]
>>> [(j, is_even(j)) for j in range(10)]
[(0, True), (1, False), (2, True), (3, False), (4, True), (5, False), (6, True), (7, False), (8, True), (9, False)]
>>>
