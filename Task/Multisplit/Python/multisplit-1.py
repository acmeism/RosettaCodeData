>>> import re
>>> def ms2(txt="a!===b=!=c", sep=["==", "!=", "="]):
	if not txt or not sep:
		return []
	ans = m = []
	for m in re.finditer('(.*?)(?:' + '|'.join('('+re.escape(s)+')' for s in sep) + ')', txt):
		ans += [m.group(1), (m.lastindex-2, m.start(m.lastindex))]
	if m and txt[m.end(m.lastindex):]:
		ans += [txt[m.end(m.lastindex):]]
	return ans

>>> ms2()
['a', (1, 1), '', (0, 3), 'b', (2, 6), '', (1, 7), 'c']
>>> ms2(txt="a!===b=!=c", sep=["=", "!=", "=="])
['a', (1, 1), '', (0, 3), '', (0, 4), 'b', (0, 6), '', (1, 7), 'c']
