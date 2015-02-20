def fib_rec(n)
  if n <= -2
    (-1)**(n + 1) * fib_rec(n.abs)
  elsif n <= 1
    n.abs
  else
    fib_rec(n - 1) + fib_rec(n - 2)
  end
end
