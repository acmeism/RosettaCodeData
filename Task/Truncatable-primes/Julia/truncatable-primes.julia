function isltruncprime{T<:Integer}(n::T, base::T=10)
    isprime(n) || return false
    p = n
    f = prevpow(base, p)
    while 1 < f
        (d, p) = divrem(p, f)
        isprime(p) || return false
        d != 0 || return false
        f = div(f, base)
    end
    return true
end

function isrtruncprime{T<:Integer}(n::T, base::T=10)
    isprime(n) || return false
    p = n
    while base < p
        p = div(p, base)
        isprime(p) || return false
    end
    return true
end

hi = 10^6

for i in reverse(primes(hi))
    isltruncprime(i) || continue
    println("The largest  left truncatable prime ≤ ", hi, " is ", i, ".")
    break
end

for i in reverse(primes(hi))
    isrtruncprime(i) || continue
    println("The largest right truncatable prime ≤ ", hi, " is ", i, ".")
    break
end
