>>> from pprint import pprint as pp
>>> pp(list(zip(*given)), width=120)
[('A', 'C', 'A', 'D', 'B', 'A', 'A', 'C', 'D', 'B', 'C', 'C', 'C', 'A', 'A', 'B', 'D', 'B', 'B', 'B', 'C', 'D', 'D'),
 ('B', 'A', 'C', 'A', 'C', 'C', 'D', 'D', 'A', 'C', 'A', 'D', 'B', 'B', 'D', 'D', 'C', 'A', 'A', 'D', 'B', 'B', 'C'),
 ('C', 'B', 'D', 'C', 'D', 'B', 'C', 'A', 'B', 'A', 'D', 'B', 'A', 'D', 'B', 'C', 'B', 'C', 'D', 'A', 'D', 'C', 'A'),
 ('D', 'D', 'B', 'B', 'A', 'D', 'B', 'B', 'C', 'D', 'B', 'A', 'D', 'C', 'C', 'A', 'A', 'D', 'C', 'C', 'A', 'A', 'B')]
>>> pp([Counter(x).most_common() for x in zip(*given)])
[[('C', 6), ('B', 6), ('A', 6), ('D', 5)],
 [('D', 6), ('C', 6), ('A', 6), ('B', 5)],
 [('D', 6), ('C', 6), ('B', 6), ('A', 5)],
 [('D', 6), ('B', 6), ('A', 6), ('C', 5)]]
>>> pp([Counter(x).most_common()[-1] for x in zip(*given)])
[('D', 5), ('B', 5), ('A', 5), ('C', 5)]
>>> pp([Counter(x).most_common()[-1][0] for x in zip(*given)])
['D', 'B', 'A', 'C']
>>> ''.join([Counter(x).most_common()[-1][0] for x in zip(*given)])
'DBAC'
>>>
