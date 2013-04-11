>>> from itertools import zip_longest
>>> print ( '\n'.join(''.join(x) for x in zip_longest('abc', 'ABCD', '12345', fillvalue='#')) )
aA1
bB2
cC3
#D4
##5
>>>
