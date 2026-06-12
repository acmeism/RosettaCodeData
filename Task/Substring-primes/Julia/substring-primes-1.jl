using Primes

const pmask = primesmask(1, 1000)

function isA085823(n, base = 10, sieve = pmask)
    dig = digits(n; base=base)
    for i in 1:length(dig), j in i:length(dig)
        k = evalpoly(base, dig[i:j])
        (k == 0 || !sieve[k]) && return false
    end
    return true
end

println(filter(isA085823, 1:1000))
