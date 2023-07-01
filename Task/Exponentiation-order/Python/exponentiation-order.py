>>> 5**3**2
1953125
>>> (5**3)**2
15625
>>> 5**(3**2)
1953125
>>> # The following is not normally done
>>> try: from functools import reduce # Py3K
except: pass

>>> reduce(pow, (5, 3, 2))
15625
>>>
