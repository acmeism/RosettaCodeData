function isprime_trialdivision{T<:Integer}(n::T)
    1 < n || return false
    n != 2 || return true
    isodd(n) || return false
    for i in 3:isqrt(n)
        n%i != 0 || return false
    end
    return true
end

n = 100
a = filter(isprime_trialdivision, [1:n])

if all(a .== primes(n))
    println("The primes <= ", n, " are:\n    ", a)
else
    println("The function does not accurately calculate primes.")
end
