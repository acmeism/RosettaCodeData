using Primes

const nt, nons = [0], Int[]

counted_primetest(n) = (nt[1] += 1; b = isprime(n); !b && push!(nons, n); b)

# start with 1 digit primes
const results = [2, 3, 5, 7]

# check 2 digit candidates
for n in results, i in [3, 7]
    if n != i
        candidate = n * 10 + i
        candidate < 100 && counted_primetest(candidate) && push!(results, candidate)
    end
end

# check 3 digit candidates
for n in results, i in [3, 7]
    if 10 < n < 100 && n % 10 != i
        candidate = n * 10 + i
        counted_primetest(candidate) && push!(results, candidate)
    end
end

println("Results: $results.\nThe function isprime() was called $(nt[1]) times.")
println("Discarded candidates: ", nons)

# Because 237, 537, and 737 are already excluded, we cannot generate any larger candidates from 373.
