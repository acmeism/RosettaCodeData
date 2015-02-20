>>> import urllib
>>> from collections import defaultdict
>>> words = urllib.urlopen('http://www.puzzlers.org/pub/wordlists/unixdict.txt').read().split()
>>> len(words)
25104
>>> anagram = defaultdict(list) # map sorted chars to anagrams
>>> for word in words:
	anagram[tuple(sorted(word))].append( word )

	
>>> count = max(len(ana) for ana in anagram.itervalues())
>>> for ana in anagram.itervalues():
	if len(ana) >= count:
		print ana

		
['angel', 'angle', 'galen', 'glean', 'lange']
['alger', 'glare', 'lager', 'large', 'regal']
['caret', 'carte', 'cater', 'crate', 'trace']
['evil', 'levi', 'live', 'veil', 'vile']
['elan', 'lane', 'lean', 'lena', 'neal']
['abel', 'able', 'bale', 'bela', 'elba']
>>> count
5
>>>
