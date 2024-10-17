function fib(n)
  x,y = (0,1)
  for i = 1:n x,y = (y, x+y) end
  x
end
