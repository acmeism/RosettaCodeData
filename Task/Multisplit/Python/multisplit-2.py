>>> def ms(txt="a!===b=!=c", sep=["==", "!=", "="]):
	if not txt or not sep:
		return []
	size = [len(s) for s in sep]
	ans, pos0 = [], 0
	def getfinds():
		return [(-txt.find(s, pos0), -sepnum, size[sepnum])
	 		 for sepnum, s in enumerate(sep)
			 if s in txt[pos0:]]

	finds = getfinds()
	while finds:
		pos, snum, sz = max(finds)
		pos, snum = -pos, -snum
		ans += [ txt[pos0:pos], [snum, pos] ]
		pos0 = pos+sz
		finds = getfinds()
	if txt[pos0:]: ans += [ txt[pos0:] ]
	return ans

>>> ms()
['a', [1, 1], '', [0, 3], 'b', [2, 6], '', [1, 7], 'c']
>>> ms(txt="a!===b=!=c", sep=["=", "!=", "=="])
['a', [1, 1], '', [0, 3], '', [0, 4], 'b', [0, 6], '', [1, 7], 'c']
