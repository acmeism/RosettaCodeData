>>> from pprint import pprint as pp
>>> from itertools import chain, combinations
>>>
>>> def powerset(iterable):
    "powerset([1,2,3]) --> () (1,) (2,) (3,) (1,2) (1,3) (2,3) (1,2,3)"
    s = list(iterable)
    return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))

>>> pp(set(powerset({1,2,3,4})))
{(),
 (1,),
 (1, 2),
 (1, 2, 3),
 (1, 2, 3, 4),
 (1, 2, 4),
 (1, 3),
 (1, 3, 4),
 (1, 4),
 (2,),
 (2, 3),
 (2, 3, 4),
 (2, 4),
 (3,),
 (3, 4),
 (4,)}
>>>
