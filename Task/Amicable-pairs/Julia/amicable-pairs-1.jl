using Primes, Printf

function pcontrib(p::Int64, a::Int64)
    n = one(p)
    pcon = one(p)
    for i in 1:a
        n *= p
        pcon += n
    end
    return pcon
end

function divisorsum(n::Int64)
    dsum = one(n)
    for (p, a) in factor(n)
        dsum *= pcontrib(p, a)
    end
    dsum -= n
end

function amicables(L = 2*10^7)
    acnt = 0
    println("Amicable pairs not greater than ", L)
    for i in 2:L
        !isprime(i) || continue
        j = divisorsum(i)
        j < i && divisorsum(j) == i || continue
        acnt += 1
        println(@sprintf("%4d", acnt), " => ", j, ", ", i)
    end
end

amicables()
