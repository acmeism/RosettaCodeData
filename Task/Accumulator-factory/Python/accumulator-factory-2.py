def accumulator(sum):
  def f(n):
    nonlocal sum
    sum += n
    return sum
  return f

x = accumulator(1)
x(5)
print(accumulator(3))
print(x(2.3))
