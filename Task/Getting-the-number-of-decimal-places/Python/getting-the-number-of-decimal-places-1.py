In [6]: def dec(n):
   ...:     return len(n.rsplit('.')[-1]) if '.' in n else 0

In [7]: dec('12.345')
Out[7]: 3

In [8]: dec('12.3450')
Out[8]: 4

In [9]:
