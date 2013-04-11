>>> with open('unixdict.txt') as f:
	wordset = set(f.read().strip().split())

>>> revlist = (''.join(word[::-1]) for word in wordset)
>>> pairs   = set((wrd, rev) for wrd, rev in zip(wordset, revlist)
                  if wrd < rev and rev in wordset)
>>> len(pairs)
158
>>> sorted(pairs, key=lambda p: (len(p[0]), p))[-5:]
[('damon', 'nomad'), ('lager', 'regal'), ('leper', 'repel'), ('lever', 'revel'), ('kramer', 'remark')]
>>>
