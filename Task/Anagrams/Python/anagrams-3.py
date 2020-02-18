>>> import urllib, itertools
>>> words = urllib.urlopen('http://wiki.puzzlers.org/pub/wordlists/unixdict.txt').read().split()
>>> len(words)
25104
>>> anagrams = [list(g) for k,g in itertools.groupby(sorted(words, key=sorted), key=sorted)]


>>> count = max(len(ana) for ana in anagrams)
>>> for ana in anagrams:
	if len(ana) >= count:
		print ana

		
['abel', 'able', 'bale', 'bela', 'elba']
['caret', 'carte', 'cater', 'crate', 'trace']
['angel', 'angle', 'galen', 'glean', 'lange']
['alger', 'glare', 'lager', 'large', 'regal']
['elan', 'lane', 'lean', 'lena', 'neal']
['evil', 'levi', 'live', 'veil', 'vile']
>>> count
5
>>>
