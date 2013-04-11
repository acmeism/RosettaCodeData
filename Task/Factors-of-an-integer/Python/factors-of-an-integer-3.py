>>> from math import sqrt
>>> def factor(n):
      factors = set()
      for x in range(1, int(sqrt(n)) + 1):
        if n % x == 0:
          factors.add(x)
          factors.add(n//x)
      return sorted(factors)

>>> for i in (45, 53, 64): print( "%i: factors: %s" % (i, factor(i)) )

45: factors: [1, 3, 5, 9, 15, 45]
53: factors: [1, 53]
64: factors: [1, 2, 4, 8, 16, 32, 64]
