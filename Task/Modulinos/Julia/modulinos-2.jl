include("divisors.jl")

using .Divisors

n = 708245926330
println("The proper divisors of $n are ", properdivisors(n))
