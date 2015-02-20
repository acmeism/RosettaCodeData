>>> def hi_index(needle, haystack):
	return len(haystack)-1 - haystack[::-1].index(needle)

>>> # Lets do some checks
>>> for n in haystack:
	hi = hi_index(n, haystack)
	assert haystack[hi] == n, "Hi index is of needle"
	assert n not in haystack[hi+1:], "No higher index exists"
	if haystack.count(n) == 1:
		assert hi == haystack.index(n), "index == hi_index if needle occurs only once"

>>>
