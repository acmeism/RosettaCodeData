>>> from itertools import permutations
>>> pieces = 'KQRrBbNN'
>>> starts = {''.join(p).upper() for p in permutations(pieces)
                     if p.index('B') % 2 != p.index('b') % 2 		# Bishop constraint
                     and ( p.index('r') < p.index('K') < p.index('R')	# King constraint	
                           or p.index('R') < p.index('K') < p.index('r') ) }
>>> len(starts)
960
>>> starts.pop()
'QNBRNKRB'
>>>
