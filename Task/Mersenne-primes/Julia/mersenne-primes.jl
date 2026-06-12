using Primes

mersenne(n::Integer) = convert(typeof(n), 2) ^ n - one(n)
function main(nmax::Integer)
    n = ith = zero(nmax)
    while ith ≤ nmax
        if isprime(mersenne(n))
            println("M$n")
            ith += 1
        end
        n += 1
    end
end

main(big(20))
