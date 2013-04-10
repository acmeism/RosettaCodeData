>>> def accumulator(sum):
  def f(n):
    f.sum += n
    return f.sum
  f.sum = sum
  return f

>>> x = accumulator(1)
>>> x(5)
6
>>> x(2.3)
8.3000000000000007
>>> x = accumulator(1)
>>> x(5)
6
>>> x(2.3)
8.3000000000000007
>>> x2 = accumulator(3)
>>> x2(5)
8
>>> x2(3.3)
11.300000000000001
>>> x(0)
8.3000000000000007
>>> x2(0)
11.300000000000001
