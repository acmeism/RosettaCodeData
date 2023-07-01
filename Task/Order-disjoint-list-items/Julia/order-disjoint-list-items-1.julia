function order_disjoint{T<:AbstractArray}(m::T, n::T)
    rlen = length(n)
    rdis = zeros(Int, rlen)
    for (i, e) in enumerate(n)
        j = findfirst(m, e)
        while j in rdis && j != 0
            j = findnext(m, e, j+1)
        end
        rdis[i] = j
    end
    if 0 in rdis
        throw(DomainError())
    end
    sort!(rdis)
    p = copy(m)
    p[rdis] = n
    return p
end
