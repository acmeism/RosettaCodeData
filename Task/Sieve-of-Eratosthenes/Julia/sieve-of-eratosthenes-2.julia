function sieve(n::Integer)
    primes = fill(true, n)
    primes[1] = false
    for p in 2:n
        primes[p] || continue
        primes[p .* (2:n÷p)] .= false
    end
    findall(primes)
end
