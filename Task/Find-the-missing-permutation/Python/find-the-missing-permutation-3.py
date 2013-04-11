>>> from collections import Counter
>>> given = '''ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA
           CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB'''.split()
>>> ''.join(Counter(x).most_common()[-1][0] for x in zip(*given))
'DBAC'
>>>
