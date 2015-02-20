def fib_iter(n)
  return 0 if n == 0
  fib_prev, fib = 1, 1
  (n.abs - 2).times { fib_prev, fib = fib, fib + fib_prev }
  fib * (n < 0 ? (-1)**(n + 1) : 1)
end
