>>>def josephus(n, k):
        r = 0
        for i in xrange(1, n+1):
            r = (r+k)%i
        return 'Survivor: %d' %r

>>> print(josephus(5, 2))
Survivor: 2
>>> print(josephus(41, 3))
Survivor: 30
>>>
