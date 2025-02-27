function isprime_trialdivision(n::Integer)
    return n == 2 || (n >= 3 && isodd(n) && all(i -> n % i != 0, 3:2:isqrt(n)))
end

n = 100
a = filter(isprime_trialdivision, 1:n)

import Primes.primes # for check, use existing library function

if all(a .== primes(n))
    println("The primes <= ", n, " are:\n    ", a)
else
    println("The function does not accurately calculate primes.")
end
