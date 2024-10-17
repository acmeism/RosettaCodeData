struct TDPrimes{T<:Integer}
    uplim::T
end

Base.start{T<:Integer}(pl::TDPrimes{T}) = 2ones(T, 1)
Base.done{T<:Integer}(pl::TDPrimes{T}, p::Vector{T}) = p[end] > pl.uplim
function Base.next{T<:Integer}(pl::TDPrimes{T}, p::Vector{T})
    pr = npr = p[end]
    ispr = false
    while !ispr
        npr += 1
        ispr = all(npr % d != 0 for d in p)
    end
    push!(p, npr)
    return pr, p
end

println("Primes ≤ 100: ", join((p for p in TDPrimes(100)), ", "))
