using Primes

function extraprimes(maxlen)
    for i in 1:maxlen, combo in Iterators.product([[2, 3, 5, 7] for _ in  1:i]...)
        if isprime(sum(combo))
            n = evalpoly(10, combo)
            isprime(n) && println(n)
        end
    end
end

extraprimes(4)
