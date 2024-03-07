fac.z <- fixp.Z (\ (f) \ (n) if (n<2) 1 else n*f(n-1))
fac.z(9) # [1] 362880

fib.z <- fixp.Z (\ (f) \ (n) if (n <= 1) n else f(n-1) + f(n-2))
fib.z(9) # [1] 34
