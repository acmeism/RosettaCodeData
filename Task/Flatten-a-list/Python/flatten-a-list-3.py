>>> def flatten(lst):
     for x in lst:
         if isinstance(x, list):
             for x in flatten(x):
                 yield x
         else:
             yield x


>>>lst = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]
>>>print list(flatten(lst))
[1, 2, 3, 4, 5, 6, 7, 8]
