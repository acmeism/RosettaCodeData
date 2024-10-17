using Primes

isalmostprime(n::Integer, k::Integer) = sum(values(factor(n))) == k

function almostprimes(N::Integer, k::Integer) # return first N almost-k primes
    P = Vector{typeof(k)}(undef,N)
    i = 0; n = 2
    while i < N
        if isalmostprime(n, k) P[i += 1] = n end
        n += 1
    end
    return P
end

for k in 1:5
    println("$k-Almost-primes: ", join(almostprimes(10, k), ", "), "...")
end
