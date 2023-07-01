def fib(n)
  raise RangeError, "fib of negative" if n < 0
  (fib2 = proc { |n| n < 2 ? n : fib2[n - 1] + fib2[n - 2] })[n]
end
