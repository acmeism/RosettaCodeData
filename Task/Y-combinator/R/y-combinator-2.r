fac.y <- fixp.Y (\ (f) \ (n) if (n<2) 1 else n*f(n-1))
fac.y(9) # [1] 362880

fib.y <- fixp.Y (\ (f) \ (n) if (n <= 1) n else f(n-1) + f(n-2))
fib.y(9) # [1] 34
