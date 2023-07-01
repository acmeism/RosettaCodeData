def fib(n)
  if n < 2
    n
  else
    prev, fib = 0, 1
    (n-1).times do
      prev, fib = fib, fib + prev
    end
    fib
  end
end

p (0..10).map { |i| fib(i) }
