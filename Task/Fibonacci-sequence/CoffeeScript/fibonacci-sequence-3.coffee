fib_rec = (n) ->
  if n < 2 then n else fib_rec(n-1) + fib_rec(n-2)
