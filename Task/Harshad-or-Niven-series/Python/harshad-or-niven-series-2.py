>>> from itertools import count, islice
>>> harshad = (n for n in count(1) if n % sum(int(ch) for ch in str(n)) == 0)
>>> list(islice(harshad, 0, 20))
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 18, 20, 21, 24, 27, 30, 36, 40, 42]
>>> next(x for x in harshad if x > 1000)
1002
>>>
