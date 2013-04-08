for i in range(1, 101):
  print 'Fizz'*(not(i%3))+'Buzz'*(not(i%5)) or i
