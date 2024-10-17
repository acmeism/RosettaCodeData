using Primes, Lazy

function samedigits(n, b)
    n, f = divrem(n, b)
    while n > 0
        n, f2 = divrem(n, b)
        if f2 != f
            return false
        end
    end
    true
end

isbrazilian(n) = n >= 7 && (iseven(n) || any(b -> samedigits(n, b), 2:n-2))
brazilians = filter(isbrazilian, Lazy.range())
oddbrazilians = filter(n -> isodd(n) && isbrazilian(n), Lazy.range())
primebrazilians = filter(n -> isprime(n) && isbrazilian(n), Lazy.range())

println("The first 20 Brazilian numbers are: ", take(20, brazilians))

println("The first 20 odd Brazilian numbers are: ", take(20, oddbrazilians))

println("The first 20 prime Brazilian numbers are: ", take(20, primebrazilians))
