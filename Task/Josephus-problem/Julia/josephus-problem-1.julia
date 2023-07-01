using Memoize
@memoize josephus(n::Integer, k::Integer, m::Integer=1) = n == m ? collect(0:m .- 1) : mod.(josephus(n - 1, k, m) + k, n)

@show josephus(41, 3)
@show josephus(41, 3, 5)
