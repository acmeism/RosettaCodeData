using Primes: isprime

PrimesGen() = Iterators.filter(isprime, Iterators.countfrom(Int64(2)))

print("Sum of first 100,000 primes:  ")
println(Iterators.sum(Iterators.take(PrimesGen(), 100000)))
print("First 20 primes:  ( ")
foreach((p->print(p," ")), Iterators.take(PrimesGen(), 20))
println(")")
print("Primes between 100 and 150:  ( ")
for p in Iterators.filter((p->p>=100), PrimesGen()) p > 150 && break; print(p, " ") end
println(")")
let cnt = 0
    for p in PrimesGen()
        p > 8000 && break; if p > 7700 cnt += 1 end
    end; println("Number of primes between 7700 and 8000:  ", cnt)
end
println("The 10,000th prime:  ", Iterators.first(Iterators.drop(PrimesGen(), 9999)))
println()
