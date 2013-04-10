def accumulator(sum):
  while True:
    sum += yield sum

x = accumulator(1)
x.send(None)
x.send(5)
print(accumulator(3))
print(x.send(2.3))
