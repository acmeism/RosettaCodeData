>>> from itertools import accumulate
>>> from random import shuffle
>>> def gen(n):
...     txt = list('[]' * n)
...     shuffle(txt)
...     return ''.join(txt)
...
>>> def balanced(txt):
...     brackets = ({'[': 1, ']': -1}.get(ch, 0) for ch in txt)
...     return all(x>=0 for x in accumulate(brackets))
...
>>> for txt in (gen(N) for N in range(10)):
...     print ("%-22r is%s balanced" % (txt, '' if balanced(txt) else ' not'))
...
''                     is balanced
']['                   is not balanced
'[]]['                 is not balanced
']][[[]'               is not balanced
'][[][][]'             is not balanced
'[[[][][]]]'           is balanced
'][[[][][]][]'         is not balanced
'][]][][[]][[]['       is not balanced
'][[]]][][[]][[[]'     is not balanced
'][[][[]]]][[[]][]['   is not balanced
