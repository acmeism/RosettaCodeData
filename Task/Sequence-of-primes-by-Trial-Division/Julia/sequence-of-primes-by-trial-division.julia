type TDPrimes{T<:Integer}
    plim::T
end

function Base.start{T<:Integer}(pl::TDPrimes{T})
    2ones(T, 1)
end

function Base.done{T<:Integer}(pl::TDPrimes{T}, p::Array{T,1})
    p[end] > pl.plim
end

function Base.next{T<:Integer}(pl::TDPrimes{T}, p::Array{T,1})
    pr = p[end]
    for i in (pr+1):(pl.plim)
        ispr = true
        for j in p
            if i%j == 0
                ispr = false
                break
            end
        end
        if ispr
            push!(p, i)
            return (pr, p)
        end
    end
    push!(p, typemax(T))
    return (pr, p)
end

n = 100
print("The primes <= ", n, " are:\n    ")

for i in TDPrimes(n)
    print(i, " ")
end
println()
