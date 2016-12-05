def nth_fib_naive(n):
  if (n < 2) then n
  else nth_fib_naive(n - 1) + nth_fib_naive(n - 2)
  end;
