IDLE 2.6.1
>>> # Number literals
>>> x,xi, y,yi = 2.0,0.5, 4.0,0.25
>>> # Numbers from calculation
>>> z  = x + y
>>> zi = 1.0 / (x + y)
>>> # The multiplier function is similar to 'compose' but with numbers
>>> multiplier = lambda n1, n2: (lambda m: n1 * n2 * m)
>>> # Numbers as members of collections
>>> numlist = [x, y, z]
>>> numlisti = [xi, yi, zi]
>>> # Apply numbers from list
>>> [multiplier(inversen, n)(.5) for n, inversen in zip(numlist, numlisti)]
[0.5, 0.5, 0.5]
>>>
