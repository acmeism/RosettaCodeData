>>> import numpy as np
>>> from random import shuffle
>>> def gen(n):
...     txt = list('[]' * n)
...     shuffle(txt)
...     return ''.join(txt)
...
>>> m = np.array([{'[': 1, ']': -1}.get(chr(c), 0) for c in range(128)])
>>> def balanced(txt):
...     a = np.array(txt, 'c').view(np.uint8)
...     return np.all(m[a].cumsum() >= 0)
...
>>> for txt in (gen(N) for N in range(10)):
...     print ("%-22r is%s balanced" % (txt, '' if balanced(txt) else ' not'))
...
''                     is balanced
']['                   is not balanced
'[[]]'                 is balanced
'[]][]['               is not balanced
']][]][[['             is not balanced
'[[]][[][]]'           is balanced
'[][[]][[]]]['         is not balanced
'[][[[]][[]]][]'       is balanced
'[[][][[]]][[[]]]'     is balanced
'][]][][[]][]][][[['   is not balanced
