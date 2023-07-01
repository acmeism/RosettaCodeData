using Primes

numfactors(n) = reduce(*, e+1 for (_,e) in factor(n); init=1)

A005179(n) = findfirst(k -> numfactors(k) == n, 1:typemax(Int))

println("The first 15 terms of the sequence are:")
println(map(A005179, 1:15))
