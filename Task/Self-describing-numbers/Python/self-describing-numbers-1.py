>>> def isSelfDescribing(n):
	s = str(n)
	return all(s.count(str(i)) == int(ch) for i, ch in enumerate(s))

>>> [x for x in range(4000000) if isSelfDescribing(x)]
[1210, 2020, 21200, 3211000]
>>> [(x, isSelfDescribing(x)) for x in (1210, 2020, 21200, 3211000, 42101000, 521001000, 6210001000)]
[(1210, True), (2020, True), (21200, True), (3211000, True), (42101000, True), (521001000, True), (6210001000, True)]
