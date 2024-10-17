using Printf: @printf

print("Sum of first 100,000 primes:  ")
println(Iterators.sum(Iterators.take(PrimesPaged(), 100000)))
print("First 20 primes:  ( ")
foreach((p->@printf("%d ", p)), Iterators.take(PrimesPaged(), 20))
println(")")
print("Primes between 100 and 150:  ( ")
for p in Iterators.filter((p->p>=100), PrimesPaged()) p > 150 && break; @printf("%d ", p)) end
println(")")
let cnt = 0
    for p in PrimesPaged()
        p > 8000 && break; if p > 7700 cnt += 1 end
    end; println("Number of primes between 7700 and 8000:  ", cnt)
end
@printf("The 10,000th prime:  %d\n", Iterators.first(Iterators.drop(PrimesPaged(), 9999)))
