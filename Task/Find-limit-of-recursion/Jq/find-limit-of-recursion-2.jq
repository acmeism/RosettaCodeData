def with_arity(n):
  if (n % 1000 == 0) then n else empty end, with_arity(n+1);

with_arity(1)
