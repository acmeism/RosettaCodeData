fac = Y( (f) -> (n) -> if n > 1 then n * f(n-1) else 1 )
fib = Y( (f) -> (n) -> if n > 1 then f(n-1) + f(n-2) else n )
