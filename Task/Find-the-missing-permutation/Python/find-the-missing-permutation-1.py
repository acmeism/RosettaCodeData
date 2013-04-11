from itertools import permutations

given = '''ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA
           CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB'''.split()

allPerms = [''.join(x) for x in permutations(given[0])]

missing = list(set(allPerms) - set(given)) # ['DBAC']
