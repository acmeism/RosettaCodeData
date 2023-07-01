'''Find the missing permutation'''

from functools import reduce
from operator import xor


print(''.join([
    chr(i) for i in reduce(
        lambda a, s: map(
            xor,
            a,
            [ord(c) for c in list(s)]
        ), [
            'ABCD', 'CABD', 'ACDB', 'DACB',
            'BCDA', 'ACBD', 'ADCB', 'CDAB',
            'DABC', 'BCAD', 'CADB', 'CDBA',
            'CBAD', 'ABDC', 'ADBC', 'BDCA',
            'DCBA', 'BACD', 'BADC', 'BDAC',
            'CBDA', 'DBCA', 'DCAB'
        ],
        [0, 0, 0, 0]
    )
]))
