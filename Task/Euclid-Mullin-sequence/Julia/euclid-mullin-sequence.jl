using Primes

struct EuclidMullin end

Base.length(em::EuclidMullin) = 1000  # not expected to get to 1000
Base.eltype(em::EuclidMullin) = BigInt
Base.iterate(em::EuclidMullin, t=big"1") = (p = first(first(factor(t + 1).pe)); (p, t * p))

println("First 16 Euclid-Mullin numbers: ", join(Iterators.take(EuclidMullin(), 16), ", "))
