julia> "# Factorial"
       fac = f -> (n -> n < 2 ? 1 : n * f(n - 1))

julia> "# Fibonacci"
       fib = f -> (n -> n == 0 ? 0 : (n == 1 ? 1 : f(n - 1) + f(n - 2)))

julia> [Y(fac)(i) for i = 1:10]
10-element Array{Any,1}:
       1
       2
       6
      24
     120
     720
    5040
   40320
  362880
 3628800

julia> [Y(fib)(i) for i = 1:10]
10-element Array{Any,1}:
  1
  1
  2
  3
  5
  8
 13
 21
 34
 55
