def fib(n)
  raise RangeError, "fib of negative" if n < 0
  (fib2 = proc { |m| m < 2 ? m : fib2[m - 1] + fib2[m - 2] })[n]
end
