>>> from itertools import takewhile, tee, islice
>>>  from collections import deque
>>> from fractions import gcd
>>>
>>> def stern_brocot():
    sb = deque([1, 1])
    while True:
        sb += [sb[0] + sb[1], sb[1]]
        yield sb.popleft()


>>> [s for _, s in zip(range(15), stern_brocot())]
[1, 1, 2, 1, 3, 2, 3, 1, 4, 3, 5, 2, 5, 3, 4]
>>> [1 + sum(1 for i in takewhile(lambda x: x != occur, stern_brocot()))
     for occur in (list(range(1, 11)) + [100])]
[1, 3, 5, 9, 11, 33, 19, 21, 35, 39, 1179]
>>> prev, this = tee(stern_brocot(), 2)
>>> next(this)
1
>>> all(gcd(p, t) == 1 for p, t in islice(zip(prev, this), 1000))
True
>>>
