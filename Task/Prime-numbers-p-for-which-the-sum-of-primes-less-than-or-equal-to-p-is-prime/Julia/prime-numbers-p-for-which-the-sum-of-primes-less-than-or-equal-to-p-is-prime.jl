using Primes

primesumto(N) = begin s = 0; [i => s for i in 1:N if isprime(i) && isprime(s += i)] end

const primesumdict = primesumto(1000)

println("Prime  Prime Sum to Prime\n---------------------------")
for p in primesumdict
    println(rpad(p[1], 7), p[2])
end
println("\nTotal such primes < 1000: ", length(primesumdict))
