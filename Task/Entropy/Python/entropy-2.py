>>> import math
>>> from collections import Counter
>>>
>>> def entropy(s):
...     p, lns = Counter(s), float(len(s))
...     return -sum( count/lns * math.log(count/lns, 2) for count in p.values())
...
>>> entropy("1223334444")
1.8464393446710154
>>>
