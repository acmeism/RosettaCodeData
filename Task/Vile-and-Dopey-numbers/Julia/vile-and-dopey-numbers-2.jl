using Lazy

isvile(n) = iseven(trailing_zeros(n))
evils = filter(isvile, Lazy.range(1))

isdopey(n) = isodd(trailing_zeros(n))
dopeys = filter(isdopey, Lazy.range(1))

println("First 25 Vile numbers:\n", take(25, evils) |> x -> join(map(string, x)," "))
println("\nFirst 25 Dopey numbers:\n", take(25, dopeys) |> x -> join(map(string, x)," "))
