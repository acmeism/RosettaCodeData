using Primes

function divisors(n::Integer)::Vector{Int}
    sort(vec(map(prod,Iterators.product((p.^(0:m) for (p,m) in eachfactor(n))...))))
end

function isCalmo(n)
    divi = divisors(n)[begin+1:end-1]
    ndiv = length(divi)
    return ndiv > 0 && ndiv % 3 == 0 && all(isprime, sum(reshape(divi, (3, :)), dims = 1))
end

println(filter(isCalmo, 1:1000))
