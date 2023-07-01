>>> def proper_divs2(n):
...     return {x for x in range(1, (n + 1) // 2 + 1) if n % x == 0 and n != x}
...
>>> [proper_divs2(n) for n in range(1, 11)]
[set(), {1}, {1}, {1, 2}, {1}, {1, 2, 3}, {1}, {1, 2, 4}, {1, 3}, {1, 2, 5}]
>>>
>>> n, length = max(((n, len(proper_divs2(n))) for n in range(1, 20001)), key=lambda pd: pd[1])
>>> n
15120
>>> length
79
>>>
