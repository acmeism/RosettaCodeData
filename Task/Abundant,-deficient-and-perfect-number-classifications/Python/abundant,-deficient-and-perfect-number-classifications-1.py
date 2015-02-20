>>> from proper_divisors import proper_divs
>>> from collections import Counter
>>>
>>> rangemax = 20000
>>>
>>> def pdsum(n):
...     return sum(proper_divs(n))
...
>>> def classify(n, p):
...     return 'perfect' if n == p else 'abundant' if p > n else 'deficient'
...
>>> classes = Counter(classify(n, pdsum(n)) for n in range(1, 1 + rangemax))
>>> classes.most_common()
[('deficient', 15043), ('abundant', 4953), ('perfect', 4)]
>>>
