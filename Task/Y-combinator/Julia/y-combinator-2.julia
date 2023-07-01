julia> fac = f -> (n -> n < 2 ? 1 : n * f(n - 1))
#9 (generic function with 1 method)

julia> fib = f -> (n -> n == 0 ? 0 : (n == 1 ? 1 : f(n - 1) + f(n - 2)))
#13 (generic function with 1 method)

julia> Y(fac).(1:10)
10-element Vector{Int64}:
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

julia> Y(fib).(1:10)
10-element Vector{Int64}:
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
