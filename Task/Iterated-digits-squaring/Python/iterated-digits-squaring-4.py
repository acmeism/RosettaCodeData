>>> from functools import lru_cache
>>> @lru_cache(maxsize=1024)
def _ids(nt):
	if nt in {('1',), ('8', '9')}: return nt
	else: return _ids(tuple(sorted(str(sum(int(d) ** 2 for d in nt)))))

	
>>> def ids(n):
	return int(''.join(_ids(tuple(sorted(str(n))))))

>>> ids(1), ids(15)
(1, 89)
>>> [ids(x) for x in range(1, 21)]
[1, 89, 89, 89, 89, 89, 1, 89, 89, 1, 89, 89, 1, 89, 89, 89, 89, 89, 1, 89]
>>> sum(ids(x) == 89 for x in range(1, 100000000))
85744333
>>> _ids.cache_info()
CacheInfo(hits=99991418, misses=5867462, maxsize=1024, currsize=1024)
>>>
