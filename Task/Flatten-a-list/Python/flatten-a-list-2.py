>>> def flatten(itr):
>>>    for x in itr:
>>>        try:
>>>            yield from flatten(x)
>>>        except:
>>>            yield x

>>> lst = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]

>>> list(flatten(lst))
[1, 2, 3, 4, 5, 6, 7, 8]

>>> tuple(flatten(lst))
(1, 2, 3, 4, 5, 6, 7, 8)

>>>for i in flatten(lst):
>>>    print(i)
1
2
3
4
5
6
7
8
