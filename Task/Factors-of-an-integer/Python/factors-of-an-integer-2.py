>>> def factors(n):
      return [i for i in range(1, n//2 + 1) if not n%i] + [n]

>>> factors(45)
[1, 3, 5, 9, 15, 45]
