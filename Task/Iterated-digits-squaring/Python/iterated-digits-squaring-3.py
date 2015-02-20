>>> from functools import lru_cache
>>> @lru_cache(maxsize=1024)
def ids(n):
	if n in {1, 89}: return n
	else: return ids(sum(int(d) ** 2 for d in str(n)))

	
>>> ids(15)
89
>>> [ids(x) for x in range(1, 21)]
[1, 89, 89, 89, 89, 89, 1, 89, 89, 1, 89, 89, 1, 89, 89, 89, 89, 89, 1, 89]
>>> sum(ids(x) == 89 for x in range(1, 100000000))
85744333
>>>
