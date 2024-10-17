# v0.6

using Primes

function mersennefactor(p::Int)::Int
    q = 2p + 1
    while true
        if log2(q) > p / 2
            return -1
        elseif q % 8 in (1, 7) && Primes.isprime(q) && powermod(2, p, q) == 1
            return q
        end
    q += 2p
    end
end

for i in filter(Primes.isprime, push!(collect(1:20), 929))
    mf = mersennefactor(i)
    if mf != -1 println("M$i = ", mf, " × ", (big(2) ^ i - 1) ÷ mf)
    else println("M$i is prime") end
end
