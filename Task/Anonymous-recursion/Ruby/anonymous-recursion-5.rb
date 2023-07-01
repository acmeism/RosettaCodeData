def fib(n)
  raise RangeError, "fib of negative" if n < 0
  Hash.new { |fib2, m|
    fib2[m] = (m < 2 ? m : fib2[m - 1] + fib2[m - 2]) }[n]
end
